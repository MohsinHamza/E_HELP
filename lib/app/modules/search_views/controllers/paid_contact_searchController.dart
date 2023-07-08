import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';
import 'package:getx_skeleton/utils/debounder_helper.dart';

import '../../../services/api_call_status.dart';

class PaidContactSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  final FirebaseFirestoreService _firestoreServices = Get.find();

  Rx<ApiCallStatus> apiCallStatus = ApiCallStatus.holding.obs;
  RxList<ContactModel> searchList = <ContactModel>[].obs;

  onSearchTextChanged(String text) {
    if (text.trim().isEmpty) {
      searchList.clear();
      apiCallStatus.value = ApiCallStatus.holding;
      update();
      return;
    }
    apiCallStatus.value = ApiCallStatus.success;
    _debouncer.debounce(() {
      _firestoreServices.searchPaidContactUser(text).then((value) {

        searchList.value = value;
        if (searchList.isEmpty) {
          apiCallStatus.value = ApiCallStatus.empty;
        } else {
          apiCallStatus.value = ApiCallStatus.success;
        }
      });
    });
  }
}

class PaidContactSearchBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaidContactSearchController());
  }
}