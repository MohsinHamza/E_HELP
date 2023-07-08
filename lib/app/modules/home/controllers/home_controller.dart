import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  static HomeController get find => Get.find();

  var currentIndex = 0.obs;

  final pages = [Routes.BOOKINGS,Routes.CONTACTS].obs;
  // final pages = [Routes.LOCATE, Routes.CONTACTS, Routes.EMERGENCY, Routes.USERS, Routes.PROFILE].obs;

  ///NAV BAR INDEX []
  ///* [0]=Locate + calendar,
  ///* [1]=Contacts,
  ///* [2]=Emergency,
  ///* [3]=Users,
  ///* [4]=Profile
  void changePage(int index, {bool fromBottom = true}) {
    currentIndex.value =index;
    if (fromBottom) {
      Get.toNamed(pages[index], id: 1);
    } else {
      Get.offNamedUntil(Routes.HOME, (route) => route.settings.name == Routes.HOME);

    }
  }
}


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}