import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/base_controller.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';

import '../../../data/models/contact_model.dart';

class EmergencyContactsController extends BaseController {
  static EmergencyContactsController get to => Get.find();

  final FirebaseFirestoreService firebaseFirestoreServices = Get.find();
  List<ContactModel>? emergencyContactList;

  void fetchEmergencyContacts() async {
    setState(ViewState.Busy);
    emergencyContactList =
        await firebaseFirestoreServices.getEmergencyContacts();

    setState(ViewState.Idle);
  }

  updateContactLocal(ContactModel? model, {bool shouldAdd = false}) {

    if (shouldAdd) {
      if (emergencyContactList == null) {
        emergencyContactList = [];
        emergencyContactList?.add(model!);
      } else {
        emergencyContactList?.insert(0, model!);
      }

    } else {
      int? index = emergencyContactList?.indexWhere((element) => element.docId == model?.docId);

      if (index != null && index >= 0) {
        emergencyContactList![index] = model!;
      }
    }
    setState(ViewState.Idle);

  }
  deleteEmergencyContact(ContactModel? model)async {
    print("***deleteing contact");
    emergencyContactList?.removeWhere((element) => element.docId == model?.docId);
    await firebaseFirestoreServices.deleteEmergencyContact(model!);
    Get.back();
    CustomSnackBar.showCustomToast(message: "Emergency Contact Deleted "
        "Successfully");
    setState(ViewState.Idle);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('ContactsController onInit');
    fetchEmergencyContacts();
  }
}

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    print("ContactsBinding");
    Get.lazyPut<EmergencyContactsController>(
      () => EmergencyContactsController(),
    );
  }
}