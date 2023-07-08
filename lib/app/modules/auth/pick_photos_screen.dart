import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../../components/reuseable_button.dart';
import 'controller/signUp_controller.dart';

class PickPhotoScreen extends GetView<SignUpController> {
  const PickPhotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.redAccent,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetBuilder<SignUpController>(builder: (c) {
                  return Stack(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.1,
                        backgroundColor: Colors.redAccent,
                        child: controller.profile == null
                            ? Image.asset(
                                'assets/svg_icons/profile.png',
                                fit: BoxFit.cover,
                                height: 340,
                                width: 340,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.file(
                                    controller.profile!,
                                    fit: BoxFit.cover,
                                    height: 340,
                                    width: 340,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 2,
                        child: GestureDetector(
                          onTap: () async {
                            await controller.showImagePickerBS(context);
                            await controller.pickProfileImage(context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(2, 3),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                  )
                                ]),
                            padding: const EdgeInsets.all(3),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      'Use Your Current ID',
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                GetBuilder<SignUpController>(
                  builder: (con) {
                    return IdPhotoPickingContainer(
                      file: controller.idFrontImage,
                      title: 'Front Side',
                      onPressed: () async {
                        await controller.showImagePickerBS(context);
                        await controller.pickFrontImage(context);
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),
                GetBuilder<SignUpController>(
                  builder: (con) {
                    return IdPhotoPickingContainer(
                      file: controller.idBackImage,
                      title: 'Back Side',
                      onPressed: () async {
                        await controller.showImagePickerBS(context);
                        await controller.pickBackImage(context);
                      },
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
        child: Reuseable_button(
          "DONE",
          AppColors.lightRed,
          SvgPicture.asset(""),
          () {
            controller.photosPicked();
          },
        ),
      ),
    );
  }
}

class IdPhotoPickingContainer extends StatelessWidget {
  bool isLoading;

  IdPhotoPickingContainer(
      {Key? key,
      required this.title,
      this.file,
      this.isLoading = false,
      this.imageUrl,
      this.isNotFound,
      required this.onPressed,
      this.height})
      : super(key: key);
  final String title;
  final File? file;
  final String? imageUrl;
  final Function onPressed;
  final double? height;
  bool? isNotFound;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff6F6F6F)),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Container(
              width: double.infinity,
              height: height ?? 188,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      spreadRadius: 2,
                    )
                  ]),
              child: Center(
                child: isLoading
                    ? isNotFound != null && isNotFound == true
                        ? const Text('Not Found')
                        : const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator())
                    : file == null && imageUrl == null
                        ? Image.asset(
                  'assets/svg_icons/add_pic.png',
                  height: 50,
                  width: 100,
                )
                        : imageUrl == null
                            ? file != null
                                ? Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: Image.file(
                                          file!,
                                          fit: BoxFit.fitWidth,
                                          width: double.infinity,
                                        )),
                                  )
                                : Image.asset(
                                    'assets/svg_icons/add_pic.png',
                                    height: 50,
                                    width: 100,
                                  )
                            : Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
