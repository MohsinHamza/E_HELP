import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../controllers/groups_controller.dart';
import '../../../../data/models/group_model.dart';
import '../../../../routes/app_pages.dart';

class FamilyEmergencyMapPage extends StatefulWidget {
  const FamilyEmergencyMapPage({Key? key}) : super(key: key);

  @override
  _FamilyEmergencyMapPageState createState() => _FamilyEmergencyMapPageState();
}

class _FamilyEmergencyMapPageState extends State<FamilyEmergencyMapPage> {
  CameraPosition? _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GroupModel? model;
  final Set<Marker> _markers = {};
  late GoogleMapController _controller;
  GlobalGroupsController? con;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool _isOpened = true;

  @override
  void initState() {
    // model = Get.arguments;
    super.initState();
    con = Get.find<GlobalGroupsController>();
    model = con!.selectedGroup;
  }

  @override
  void dispose() {
    _controller.dispose();

    _membersController.dispose();
    _customInfoWindowController.dispose();
    super.dispose();
  }

  final ScrollController _membersController = ScrollController();
  @override
  Widget build(BuildContext context) {
    createMarkers(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model!.name,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            InkWell(
              onTap: () async {
                Get.toNamed(Routes.ADDGROUPMEMBER);

              },
              child: const Icon(
                Icons.person_add,
                size: 34,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
              height: 90,
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(2, 1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Scrollbar(
                  controller: _membersController,
                  thumbVisibility: true,
                  thickness: 0.8,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: _membersController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...model!.members!.map((e) => GestureDetector(
                              onTap: () {
                                _controller.moveCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: e.position,
                                      zoom: 17.35,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 81,
                                margin: const EdgeInsets.only(right: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      e.image,
                                      width: 60,
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      e.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _kGooglePlex!,
                  markers: _markers,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 177,
                  width: 150,
                  offset: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  createMarkers(BuildContext context) {
    Marker marker;

    model!.members!.forEach((contact) async {
      marker = Marker(
          markerId: MarkerId(contact.name),
          position: contact.position,
          icon: await _getAssetIcon(context, contact.marker)
              .then((value) => value),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.2,
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Share Live location for',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Live Location shared for 1 hour');
                            _customInfoWindowController.hideInfoWindow!();
                          },
                          child: Container(
                            width: 130,
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                              ),
                            )),
                            height: 40,
                            child: const Center(
                              child: Text('1 Hour'),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Live Location shared for 24 hour');
                            _customInfoWindowController.hideInfoWindow!();
                          },
                          child: Container(
                            width: 130,
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Colors.black12,
                              ),
                            )),
                            height: 40,
                            child: const Center(
                              child: Text('24 Hour'),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Live Location shared Indefinitely');
                            _customInfoWindowController.hideInfoWindow!();
                          },
                          child: Container(
                            width: 130,
                            padding: const EdgeInsets.only(top: 3),
                            decoration: const BoxDecoration(),
                            height: 40,
                            child: const Center(
                              child: Text('Indefinite'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              contact.position,
            );
          });

      setState(() {
        _markers.add(marker);
      });
    });
  }

  Future<BitmapDescriptor> _getAssetIcon(
      BuildContext context, String icon) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config =
        createLocalImageConfiguration(context, size: const Size(5, 5));

    AssetImage(icon)
        .resolve(config)
        .addListener(ImageStreamListener((ImageInfo image, bool sync) async {
      final ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    }));

    return await bitmapIcon.future;
  }
}

class CustomMarker extends StatelessWidget {
  const CustomMarker({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/markers/marker-1.png',
          width: 60,
        ),
        Positioned(
          left: 12,
          top: 2,
          child: Image.asset(
            imagePath,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

// Positioned(
//   top: 10,
//   left: 10,
//   child: InkWell(
//     onTap: () {
//       setState(() {
//         _isOpened = !_isOpened;
//       });
//     },
//     child: Container(
//       decoration:
//           const BoxDecoration(shape: BoxShape.circle, boxShadow: [
//         BoxShadow(
//           offset: Offset(2, 1),
//           color: Colors.black12,
//           spreadRadius: 1,
//           blurRadius: 1,
//         )
//       ]),
//       child: CircleAvatar(
//         backgroundColor: Colors.white,
//         child: Center(
//           child: _isOpened == false
//               ? const Icon(
//                   Icons.arrow_forward_ios_outlined,
//                 )
//               : const Icon(
//                   Icons.close,
//                 ),
//         ),
//       ),
//     ),
//   ),
// ),
// Positioned(
//   top: 60,
//   left: 10,
//   child: _isOpened
//       ? Container(
//           width: 100,
//           height: 400,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(
//                   offset: Offset(2, 1),
//                   spreadRadius: 2,
//                   blurRadius: 2,
//                   color: Colors.black12,
//                 )
//               ]),
//           child: Scrollbar(
//             thumbVisibility: true,
//             controller: _membersController,
//             //trackVisibility: true,
//             radius: const Radius.circular(10),
//             child: ListView.builder(
//               controller: _membersController,
//               scrollDirection: Axis.horizontal,
//               itemCount: Data().contacts.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     _controller.moveCamera(
//                       CameraUpdate.newCameraPosition(
//                         CameraPosition(
//                             target: Data().contacts[index]['position'],
//                             zoom: 17.35),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: 60,
//                     height: 100,
//                     margin: const EdgeInsets.only(right: 10),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           Data().contacts[index]['image'],
//                           width: 60,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           Data().contacts[index]["name"],
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ))
//       : const SizedBox(),
// )
// class FamilyPage extends GetView {
//   const FamilyPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             GoogleMap(
//               mapType: MapType.terrain,
//               markers: {},
//               zoomControlsEnabled: false,
//               zoomGesturesEnabled: true,
//               initialCameraPosition: const CameraPosition(
//                 bearing: 12.8334901395799,
//                 target: LatLng(43.810190, -79.202590),
//                 tilt: 59.440717697143555,
//                 zoom: 14,
//               ),
//               onMapCreated: (GoogleMapController controller) {},
//               polylines: {},
//             ),
//             Positioned(
//               top: 10,
//               left: 10,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: const CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 8.0),
//                       child: Icon(Icons.arrow_back_ios),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
