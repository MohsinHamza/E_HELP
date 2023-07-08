import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/base_controller.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';
import 'package:getx_skeleton/app/services/logger_services.dart';
import 'package:getx_skeleton/utils/firebasepaths.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../components/custom_snackbar.dart';
import '../../../data/models/contact_model.dart';
import '../../../services/firebase_storage_services.dart';
import '../../nav_contacts/controller/emergency_contacts_controller.dart';
import '../success_fullyadd_contacts.dart';

class AddEmergencyContactsController extends BaseController {
  static AddEmergencyContactsController get from => Get.find();
  final FirebaseFirestoreService firebaseFirestoreServices = Get.find();
  final FirebaseStorageService firebaseStorageService = Get.find();
  final MyAppUser myAppUser = Get.find();
  ContactModel? contact;
  XFile? file;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneNumberC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController relationC = TextEditingController();
  final TextEditingController pictureC = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  validateField(ContactModel? model) async {
    if (formKey.currentState?.validate() ?? false) {
      print("SUCCESSS");
      await addOrUpdateEmergencyContact(contactModel: model);
      model == null
          ? Get.to(Add_contacts_successfully(
              model: contact!,
            ))
          : null;
    }
  }





  addOrUpdateEmergencyContact({ContactModel? contactModel}) async {
    if (formKey.currentState?.validate() ?? false) {
      setState(ViewState.Busy);
      ContactModel model = ContactModel();
      if (file != null) {
        pictureC.text =
            await firebaseStorageService.uploadAFileToStorage(File(file!.path), StoragePath.userImages(myAppUser.id ?? "", file!.path));
      }
      model.name = nameC.text;
      model.phoneNumber = phoneNumberC.text;
      model.address = '';
      model.relation = relationC.text;
      model.picture = pictureC.text;

      if (contactModel == null) {
        await firebaseFirestoreServices.addEmergencyContact(model);
        _updateContactModelLocal(model, shouldAdd: true);
        contact = model;
      } else {
        contactModel.name = nameC.text;
        contactModel.phoneNumber = phoneNumberC.text;
        contactModel.address = '';
        contactModel.relation = relationC.text;
        contactModel.picture = pictureC.text;
        await firebaseFirestoreServices.updateEmergencyContact(contactModel);
        _updateContactModelLocal(contactModel);
      }

      setState(ViewState.Idle);
      Get.back();
      contactModel == null ? Get.to(Add_contacts_successfully(model: contact!)) : null;
      CustomSnackBar.showCustomToast(
          message: contactModel == null ? "Emergency Contact Added Succesfully" : 'Contact updated successfully');
    }
  }

  bool _isInit = true;

  fillFields({required ContactModel? contactModel}) {
    if (_isInit == false) return;
    _isInit = false;
    LoggerServices.find.log('fillFields ${contactModel?.toJson()}');
    nameC.text = contactModel?.name ?? "";
    phoneNumberC.text = contactModel?.phoneNumber ?? "";
    addressC.text = contactModel?.address ?? "";
    relationC.text = contactModel?.relation ?? "";
    pictureC.text = contactModel?.picture ?? "";
    // setState(ViewState.Idle);
  }

  ///Updates the data locallly.....
  _updateContactModelLocal(ContactModel? contactModel, {bool shouldAdd = false}) {
    Get.find<EmergencyContactsController>().updateContactLocal(contactModel, shouldAdd: shouldAdd);
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
}

class AddEmergencyContactsBinding extends Bindings {
  @override
  void dependencies() {
    debugPrint("AddEmergencyContactsController ");
    Get.lazyPut<AddEmergencyContactsController>(
      () => AddEmergencyContactsController(),
    );
  }
}