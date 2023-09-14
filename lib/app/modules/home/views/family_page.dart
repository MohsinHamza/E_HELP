import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class FamilyPage extends StatefulWidget {
  const FamilyPage({Key? key}) : super(key: key);

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  late GoogleMapController _controller;

  final List<dynamic> _contacts = [
    // {
    //   "name": "Me",
    //   "position": const LatLng(37.42796133580664, -122.085749655962),
    //   "marker": 'assets/markers/marker-1.png',
    //   "image": 'assets/images/avatar-1.png',
    // },
    {
      "name": "Samantha",
      "position": const LatLng(37.42484642575639, -122.08309359848501),
      "marker": 'assets/markers/marker-2.png',
      "image": 'assets/images/avatar-2.png',
    },
    {
      "name": "Malte",
      "position": const LatLng(37.42381625902441, -122.0928531512618),
      "marker": 'assets/markers/marker-3.png',
      "image": 'assets/images/avatar-3.png',
    },
    {
      "name": "Julia",
      "position": const LatLng(37.41994095849639, -122.08159055560827),
      "marker": 'assets/markers/marker-4.png',
      "image": 'assets/images/avatar-4.png',
    },
    {
      "name": "Tim",
      "position": const LatLng(37.413175077529935, -122.10101041942836),
      "marker": 'assets/markers/marker-5.png',
      "image": 'assets/images/avatar-5.png',
    },
    {
      "name": "Sara",
      "position": const LatLng(37.419013242401576, -122.11134664714336),
      "marker": 'assets/markers/marker-6.png',
      "image": 'assets/images/avatar-6.png',
    },
    {
      "name": "Ronaldo",
      "position": const LatLng(37.40260962243491, -122.0976958796382),
      "marker": 'assets/markers/marker-7.png',
      "image": 'assets/images/avatar-7.png',
    },
  ];

  bool _isOpened = true;

  @override
  void initState() {
    super.initState();
  }

  final ScrollController _membersController = ScrollController();
  @override
  Widget build(BuildContext context) {
    createMarkers(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Family Members',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isOpened = !_isOpened;
                  });
                },
                child: Container(
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 1),
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: _isOpened == false
                          ? const Icon(
                              Icons.arrow_forward_ios_outlined,
                            )
                          : const Icon(
                              Icons.close,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 10,
              child: _isOpened
                  ? Container(
                      width: 100,
                      height: 400,
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
                          ]),
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _membersController,
                        //trackVisibility: true,
                        radius: const Radius.circular(10),
                        child: ListView.builder(
                          controller: _membersController,
                          scrollDirection: Axis.vertical,
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _controller.moveCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        target: _contacts[index]['position'],
                                        zoom: 17.35),
                                  ),
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 100,
                                margin: const EdgeInsets.only(right: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      _contacts[index]['image'],
                                      width: 60,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _contacts[index]["name"],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ))
                  : const SizedBox(),
            )
          ],
        ));
  }

  createMarkers(BuildContext context) {
    Marker marker;

    _contacts.forEach((contact) async {
      marker = Marker(
        markerId: MarkerId(contact['name']),
        position: contact['position'],
        icon: await _getAssetIcon(context, contact['marker'])
            .then((value) => value),
        infoWindow: InfoWindow(
          title: contact['name'],
          snippet: 'Street 6 . 2min ago',
        ),
      );

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
  const CustomMarker({Key? key,required this.imagePath}) : super(key: key);
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
          top: 7,
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
