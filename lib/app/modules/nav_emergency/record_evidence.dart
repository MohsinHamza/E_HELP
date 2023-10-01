import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/app/services/firebase_storage_services.dart';
import 'package:getx_skeleton/utils/firebasepaths.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordEvidenceControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordEvidenceController>(
      () => RecordEvidenceController(),
    );
  }
}

class RecordEvidenceController extends GetxController {
  static RecordEvidenceController get from => Get.find();
  final FirebaseStorageService firebaseStorageService = Get.find();
  int index = 0;
  XFile? file;
  final ImagePicker _picker = ImagePicker();
  RxList<Widget> pages = [
    const EvidenceType(),
  ].obs;
  void checkBoxChange(int index) {
    this.index = index;
    update();
  }

  captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        file = image;
        final MyAppUser myAppUser = Get.find<MyAppUser>();
        String evidenceLink = '';
        if (file != null) {
          CustomSnackBar.showCustomSnackBar(
              title: "Image Evidence",
              message: "Your image evidence has been uploading.");
          debugPrint("uploading");
          try {
            evidenceLink = await firebaseStorageService.uploadAFileToStorage(
                File(file!.path),
                StoragePath.userEvidenceImages(myAppUser.id ?? "", file!.path));
            CustomSnackBar.showCustomSnackBar(
                title: "Image Evidence",
                message: "Your image evidence has been uploaded.");
          } on FirebaseException catch (e) {
            CustomSnackBar.showCustomErrorToast(
                title: "Error", message: e.message.toString());
          } catch (e) {
            CustomSnackBar.showCustomErrorToast(
                title: "Error",
                message: "Something went wrong, please try again later.");
          }
        }

        if (evidenceLink != '') {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(myAppUser.id)
              .collection('evidences')
              .doc()
              .set({
            'created_at': DateTime.now().millisecondsSinceEpoch,
            'evidenceLink': evidenceLink,
            'fileType': 'image',
            'fileName': StoragePath.userEvidenceImages(
              myAppUser.id ?? "",
              file!.path,
            ).name,
            'fullPath': StoragePath.userEvidenceImages(
              myAppUser.id ?? "",
              file!.path,
            ).fullPath,
          });
        }
      }
      update();
    } catch (e) {
      print('Exception: ' + e.toString());
    }
  }

  recordVideo() async {
    try {
      final XFile? image = await _picker.pickVideo(source: ImageSource.camera);
      if (image != null) {
        file = image;
        final MyAppUser myAppUser = Get.find<MyAppUser>();
        String evidenceLink = '';
        if (file != null) {
          CustomSnackBar.showCustomSnackBar(
              title: "Video Evidence",
              message: "Your video evidence has been uploading.");
          debugPrint("uploading");
          try {
            evidenceLink =
                await firebaseStorageService.uploadVideoFileToStorage(
              file!,
              StoragePath.userEvidenceImages(
                myAppUser.id ?? "",
                file!.path,
              ),
            );
            CustomSnackBar.showCustomSnackBar(
                title: "Video Evidence",
                message: "Your video evidence has been uploaded.");
          } on FirebaseException catch (e) {
            CustomSnackBar.showCustomErrorToast(
                title: "Error", message: e.message.toString());
          } catch (e) {
            CustomSnackBar.showCustomErrorToast(title: "I am", message: "$e");
          }
        }

        if (evidenceLink != '') {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(myAppUser.id)
              .collection('evidences')
              .doc()
              .set({
            'created_at': DateTime.now().millisecondsSinceEpoch,
            'evidenceLink': evidenceLink,
            'fileType': 'video',
            'fileName': StoragePath.userEvidenceImages(
              myAppUser.id ?? "",
              file!.path,
            ).name,
            'fullPath': StoragePath.userEvidenceImages(
              myAppUser.id ?? "",
              file!.path,
            ).fullPath,
          });
        }
      }
      update();
    } catch (e) {
      print('Exception: ' + e.toString());
    }
  }
}

class RecordEvidence extends GetView<RecordEvidenceController> {
  RecordEvidence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 90,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 90,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  [
                        const Icon(
                          Icons.home,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Home',
                          style: GoogleFonts.montserrat(
                              color: Colors.redAccent,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              const Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/icons/men_logo.png'),
                  height: 250,
                  width: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const EvidenceType()
            ],
          ),
        ),
      ),
    );
  }
}

class EvidenceType extends StatefulWidget {
  const EvidenceType({Key? key}) : super(key: key);

  @override
  State<EvidenceType> createState() => _EvidenceTypeState();
}

class _EvidenceTypeState extends State<EvidenceType> {
  bool _isYes = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height * 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: !_isYes,
          child: Text(
            "Do you want to record a video or take a picture for evidence?",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: _isYes,
          child: Column(
            children: [
              RecordButton(
                onPressed: () async {
                  await Get.find<RecordEvidenceController>().recordVideo();
                },
                title: 'Record Video',
              ),
              const SizedBox(
                height: 20,
              ),
              RecordButton(
                onPressed: () async {
                  await Get.find<RecordEvidenceController>().captureImage();
                },
                title: 'Take Picture',
              ),
            ],
          ),
        ),
        Visibility(
          visible: !_isYes,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              RecordButton(
                onPressed: () async {
                  if (await Permission.camera.isPermanentlyDenied) {
                    openAppSettings();
                  }
                  setState(() {
                    _isYes = true;
                  });
                },
                title: 'Yes',
              ),
              const SizedBox(
                height: 15,
              ),
              RecordButton(
                onPressed: () async {
                  Get.back();
                },
                title: 'No',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RecordButton extends StatefulWidget {
  const RecordButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);
  final String title;
  final Function() onPressed;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 3),
                blurRadius: 3,
                spreadRadius: 0,
                color: Color(0xffFF6D6D),
              )
            ]),
        child: Center(
          child: Text(
            widget.title,
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
