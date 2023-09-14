import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/camera_image_picker_view.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart' hide PermissionStatus;
import 'package:sms_mms/sms_mms.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/components/reuseable_button.dart';

class Functions {
  static bool isGranted=false;


  ///returns true is permission is granted,,,
  static Future<bool> isLocationPermissionGranted() async {

    bool isGranted = false;
    try {
      if (await Permission.location.isGranted) {
        isGranted = true;
      }
    } catch (e) {
      Logger().e(e);
    }

    return isGranted;
  }

  //Determines postion of the user and returns a list of lat and long
  static Future<LocationData?> getMyPosition() async {
    Location location = Location();

    bool _serviceEnabled;
    bool _permissionGranted=false;
    LocationData? _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }
    }

   _permissionGranted = await isLocationPermissionGranted();
    if(_permissionGranted){
      _locationData = await location.getLocation();
    }
   return _locationData;
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  ///Give model.captureImage() and model.pickImage() to get the image from camera or gallery
  static showImagePickerBS(context, {required model}) {
    showModalBottomSheet(
      context: context,
      elevation: 10.0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      builder: (context) => CameraImagePickerView(
        pickFromCamera: () {
          model.captureImage();
          Navigator.pop(context);
        },
        pickFromGallery: () {
          model.pickImage();
          Navigator.pop(context);
        },
      ),
    );
  }

  // static Future<bool> requestForLocationPermission() async {
  //   bool isGranted = false;
  //   try {
  //     if (await Permission.location.isGranted) {
  //       isGranted = true;
  //     } else {
  //       var status = await Permission.location.request();
  //       print(status);
  //       if (status.isGranted || status.isLimited) {
  //         isGranted = true;
  //       } else {
  //         openAppSettings();
  //       }
  //     }
  //   } catch (e) {
  //     Logger().e(e);
  //   }
  //
  //   return isGranted;
  // }

  static Future<bool?> checkLocationPermission() async {
    Location location = Location();
    bool serviceEnabled = false;
    PermissionStatus permissionGranted = PermissionStatus.granted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        openAppSettings();
        return false;
      }
    }

    await location.hasPermission().then((PermissionStatus value){
      permissionGranted = value;
      isGranted = true;
      return isGranted;
    });
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return false;
  }
  static Future<bool> requestForLocationPermission() async {
    await checkLocationPermission();
    bool isGranted = false;
    try {
      if (await Permission.location.isGranted) {
        isGranted = true;
      } else {
        var status = await Permission.location.request();
        print(status);
        if (status.isGranted || status.isLimited) {
          isGranted = true;
        } else {
          openAppSettings();
        }
      }
    } catch (e) {
      Logger().e(e);
    }

    return isGranted;
  }

  static Future<File> compressFile(String filepath) async {
    File compressedFile = await FlutterNativeImage.compressImage(filepath, quality: 50);

    return compressedFile;
  }

  ///shows confirm dialog...
  static void showConfirmDialog({required confirm, required String content, required String title}) {
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.only(top: 20),
      radius: 15,
      contentPadding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom, left: 10, right: 10, top: 15),
      backgroundColor: Colors.white,
      // title: 'Detail Of The Day',
      content: Center(
          child: Column(
        children: [
          Text(
            content.toString(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Reuseable_button("Cancel", AppColors.Kgrey_type, SvgPicture.asset(""), () {
                    if (Get.isDialogOpen!) {
                      Get.back();
                    }
                  }, shouldHavePadding: false),
                ),
                const Expanded(
                  flex: 1,
                  child: const SizedBox(
                    width: 30,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Reuseable_button(
                    "Confirm",
                    AppColors.lightRed,
                    SvgPicture.asset(""),
                    confirm,
                    shouldHavePadding: false,
                  ),
                ),
              ],
            ),
          )
        ],
      )),

      // confirm: Container(
      //     padding: const EdgeInsets.only(bottom: 10),
      //     child: Reuseable_button(
      //         "Confirm", AppColors.Sdark_blue, SvgPicture.asset(""), confirm)),
      // cancel: Container(
      //   padding: const EdgeInsets.only(bottom: 10),
      //   child: Reuseable_button(
      //       "Cancel", AppColors.Kgrey_type, SvgPicture.asset(""), () {
      //     if (Get.isDialogOpen!) {
      //       Get.back();
      //     }
      //   }),
      // ),
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  static openEmailAppSupport({String? body, String? subject}) async {
    String sub = subject ?? "Feeback M.E.N Customer App";
    await launch("mailto: helpdesk@medicalemergencynetwork.com?subject=$sub&body=$body");
  }

  static sendMessage(String number, String body) async {
    if (Platform.isAndroid) {
      String _body = body.replaceAll(" ", "%20");
      String url = "sms:$number?body=$_body";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      //for ios

      await SmsMms.send(
        recipients: [number],
        message: body,
      );
    }

    // String _body = body.replaceAll(" ", "%20");
    // String url = "sms:$number?body=$_body";
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}

class Debouncer {
  Duration? delay;
  Timer? _timer;
  VoidCallback? _callback;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void debounce(VoidCallback callback) {
    this._callback = callback;

    this.cancel();
    _timer = new Timer(delay!, this.flush);
  }

  void cancel() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void flush() {
    this._callback!();
    this.cancel();
  }
}