import 'package:get/get.dart';

class LocationController extends GetxController {
  static LocationController get to => Get.find();
}

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(
      () => LocationController(),
    );
  }
}
