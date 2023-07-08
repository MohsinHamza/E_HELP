import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/DateFormate_utils.dart';
import '../../../../utils/firebasepaths.dart';
import '../../../controllers/my_app_user.dart';
import '../../../services/FirebaseFirestoreServices.dart';
import '../../../services/firebase_storage_services.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  final FirebaseFirestoreService firebaseFirestoreServices = Get.find();
  final FirebaseStorageService firebaseStorageService = Get.find();

  @override
  onInit() {
    super.onInit();
    fillFields();
  }

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController profileImage = TextEditingController();
  TextEditingController name = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? file;
  bool _isEditMode = false;
  final MyAppUser myAppUser = Get.find<MyAppUser>();
  String dummyDate = 'No Date of Birth Provided';

  fillFields() {
    phoneNumber.text = myAppUser.phonenumber ?? "";
    profileImage.text = myAppUser.profileurl ?? "";
    name.text = myAppUser.name ?? '...';
    dummyDate = CustomeDateFormate.DOB(myAppUser.dob);
  }

  saveButton() async {
    if (file != null) {
      CustomSnackBar.showCustomSnackBar(
          title: "Image", message: "Updating your profile picture");
      debugPrint("uploading");
      try {
        profileImage.text = await firebaseStorageService.uploadAFileToStorage(
            File(file!.path), StoragePath.userImages(myAppUser.id!, file!.path));
        await firebaseFirestoreServices.updateProfilePicture(
            url: profileImage.text);
        myAppUser.profileurl = profileImage.text;
        FirebaseAuth.instance.currentUser!.updatePhotoURL(myAppUser.profileurl);
        myAppUser.update(myAppUser);
        isEditMode = false;
        CustomSnackBar.showCustomSnackBar(
            title: "Profile updated",
            message: "Your Profile photo has been updated.");
      } on FirebaseException catch (e) {
        isEditMode = false;
        CustomSnackBar.showCustomErrorToast(
            title: "Error", message: e.message.toString());
      } catch (e) {
        isEditMode = false;
        CustomSnackBar.showCustomErrorToast(
            title: "Error",
            message: "Something went wrong, please try again later.");
      }
    }
    if (name.text != myAppUser.name) {
      CustomSnackBar.showCustomSnackBar(
          title: "Name", message: "Updating Name");
      myAppUser.name = name.text;
      await firebaseFirestoreServices.updateName(url: myAppUser.name ?? '');

      myAppUser.update(myAppUser);
      isEditMode = false;
      CustomSnackBar.showCustomSnackBar(
          title: "Name updated", message: "Your Name has been updated.");
    }
    if (phoneNumber.text != myAppUser.phonenumber) {
      CustomSnackBar.showCustomSnackBar(
          title: "PHONE NUMBER", message: "Updating phone number");
      await firebaseFirestoreServices.updatePhoneNumber(
          newPhoneNumber: phoneNumber.text);
      myAppUser.phonenumber = phoneNumber.text;
      myAppUser.update(myAppUser);
      isEditMode = false;
      CustomSnackBar.showCustomSnackBar(
          title: "Phone Number updated",
          message: "Your Phone number has been updated.");
    }
    await firebaseFirestoreServices.updateDOB(url: myAppUser.dob);
    isEditMode = false;
  }

  toggleEditMode() {
    isEditMode = !isEditMode;
    if (isEditMode == false) {
      file = null;
    }
  }

  captureImage() async {
    try {
      if (await Permission.camera.isPermanentlyDenied) {
        openAppSettings();
      }
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        file = image;
      }
      update();
    } catch (e) {
      print('Exception: ' + e.toString());
    }
  }

  pickImage() async {
    try {
      if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        file = image;
      }
      update();
    } catch (e) {
      print('Exception: ' + e.toString());
    }
  }

  bool get isEditMode => _isEditMode;

  set isEditMode(bool value) {
    _isEditMode = value;
    update();
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
