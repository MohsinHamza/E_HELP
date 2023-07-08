import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/services/firebase_storage_services.dart';
import 'package:getx_skeleton/utils/DateFormate_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../components/CacheNetworkWidget.dart';
import '../../controllers/my_app_user.dart';
import '../../routes/app_pages.dart';

class MyEvidencesControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyEvidencesController>(
      () => MyEvidencesController(),
    );
  }
}

class MyEvidencesController extends GetxController {
  static MyEvidencesController get from => Get.find();
  final FirebaseStorageService firebaseStorageService = Get.find();
}

class MyEvidences extends GetView<MyEvidencesController> {
  MyEvidences({Key? key}) : super(key: key);
  final MyAppUser myAppUser = Get.find<MyAppUser>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 90,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Row(
              children:  const [
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 25,
                ),
              ],
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'My Evidences',
                    style: GoogleFonts.montserrat(
                        color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(
                    Routes.RECORDEVIDENCE,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Record',
                      style: GoogleFonts.montserrat(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.video_camera_front_rounded,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(myAppUser.id)
                .collection('evidences')
                .orderBy('created_at')
                .snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                );
              } else {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Unexpected Error',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      List<Map<String, dynamic>> evidences = [];
                      for (var map in snapshot.data!.docs) {
                        var data = map.data() as Map<String, dynamic>;
                        evidences.add(data);
                      }
                      if (evidences.isNotEmpty) {
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          itemCount: evidences.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 6 / 8.2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (_, index) {
                            return EvidenceWidget(
                              evidenceItem: evidences[index],
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'No Evidences Found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text(
                          'No Evidences Found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text(
                        'No Evidences Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

enum Options { delete, download }

class EvidenceWidget extends StatefulWidget {
  const EvidenceWidget({Key? key, required this.evidenceItem})
      : super(key: key);
  final Map<String, dynamic> evidenceItem;
  @override
  State<EvidenceWidget> createState() => _EvidenceWidgetState();
}

class _EvidenceWidgetState extends State<EvidenceWidget> {
  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      onTap: () async {
        position == Options.delete.index ? await delete() : await download();
      },
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
            size: 23,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
      widget.evidenceItem['created_at'],
    ));
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.white38,
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          widget.evidenceItem['fileType'] == 'video'
              ? VideoPlayerWidget(
                  name: widget.evidenceItem['evidenceLink'],
                )
              : CacheNetworkWidget(
                  height: double.infinity,
                  imageUrl: widget.evidenceItem['evidenceLink'],
                ),
          Positioned(
            top: 3,
            right: 3,
            child: PopupMenuButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  _buildPopupMenuItem(
                      'Download', Icons.download, Options.download.index),
                  _buildPopupMenuItem(
                      'Delete', Icons.delete, Options.delete.index),
                ];
              },
              child: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.black87,
              width: 200,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    CustomeDateFormate.DDMMMMDDDD(
                      DateTime.fromMillisecondsSinceEpoch(
                        widget.evidenceItem['created_at'],
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var progressNotifier = ValueNotifier<double?>(0);
  delete() async {
    final MyAppUser myAppUser = Get.find<MyAppUser>();
    final islandRef =
        FirebaseStorage.instance.ref(widget.evidenceItem['fullPath']);
    await islandRef.delete();
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(myAppUser.id)
        .collection('evidences')
        .where('fullPath', isEqualTo: widget.evidenceItem['fullPath'])
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) {
      var id = snap.docs[0].id;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myAppUser.id)
          .collection('evidences')
          .doc(id)
          .delete();
    }
  }

  download() async {
    final islandRef =
        FirebaseStorage.instance.ref(widget.evidenceItem['fullPath']);

    final appDocDir = await getTemporaryDirectory();
    final filePath = join(appDocDir.path, widget.evidenceItem['fileName']);
    //     "${appDocDir.absolute}/evidences/${widget.evidenceItem['fileName']}";
    final file = File(filePath);
    print(filePath);

    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          progressNotifier.value =
              taskSnapshot.totalBytes / taskSnapshot.bytesTransferred;
          break;
        case TaskState.paused:
          CustomSnackBar.showCustomToast(message: 'Downloading Paused');
          break;
        case TaskState.success:
          CustomSnackBar.showCustomToast(
              message: 'Your file has been downloaded');
          if (widget.evidenceItem['fileType'] == 'video') {
            GallerySaver.saveVideo(file.path, toDcim: true).then((value) {
              CustomSnackBar.showCustomToast(
                  message: 'Your video is Saved to Gallery');
            });
          } else {
            GallerySaver.saveImage(file.path, toDcim: true).then((value) {
              CustomSnackBar.showCustomToast(
                  message: 'Your image is Saved to Gallery');
            });
          }
          break;
        case TaskState.canceled:
          CustomSnackBar.showCustomToast(message: 'File Downloading canceled');
          break;
        case TaskState.error:
          CustomSnackBar.showCustomToast(message: TaskState.error.name);
          break;
      }
    });
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  var _isLoading = true;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    // final _url = await downloadVideoURL(widget.name);
    _videoPlayerController = VideoPlayerController.network(widget.name);
    initializeVideoPlayerFuture = _videoPlayerController!.initialize();
    _isLoading = false;
    setState(() {});
  }

  // Future<String> downloadVideoURL(String videoFile) async {
  //   try {
  //     String downloadURL = await FirebaseStorage.instance
  //         .ref("users/$useruid/userEvidenceImages/${p.basename(filePath)}")
  //         .getDownloadURL();
  //
  //     return downloadURL;
  //   } on FirebaseException catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  //   return '';
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 6 / 8.2,
            child: Stack(
              children: [
                VideoPlayer(_videoPlayerController!),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.12,
                  left: MediaQuery.of(context).size.height * 0.08,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerController!.value.isPlaying
                            ? _videoPlayerController!.pause()
                            : _videoPlayerController!.play();
                      });
                    },
                    icon: _videoPlayerController!.value.isPlaying
                        ? const Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 50,
                          )
                        : const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 50,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  width: MediaQuery.of(context).size.width,
                  child: VideoProgressIndicator(
                    _videoPlayerController!,
                    allowScrubbing: false,
                    colors: const VideoProgressColors(
                      backgroundColor: Colors.grey,
                      bufferedColor: Colors.red,
                      playedColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
