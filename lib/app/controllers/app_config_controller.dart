import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';
import 'package:getx_skeleton/utils/functions.dart';

import '../data/local/price_model.dart';

class AppConfigController extends GetxController implements GetxService {
  List<PriceModel> priceList = [];

  @override
  void onInit() {
    //checks permission here.
    Functions.isLocationPermissionGranted().then((value) {
      setLocationPermission = value;
      if (value) {
        updateMyLocationInFirebase();
      }
    });
    getPriceList();
    super.onInit();
  }

  getPriceList() async {
    priceList = await Get.find<FirebaseFirestoreService>().getPriceList();
    // debugPrint(priceList.first.toMap().toString());
    update();
  }

  updateMyLocationInFirebase() {
    try {
      Functions.getMyPosition().then((value) {
        if (value != null) {
          Get.find<FirebaseFirestoreService>()
              .updateMyAppUserLocation(value.latitude, value.longitude);
        } else {
          Get.snackbar('Enable Location',
              'Some issue with your location, enable and try again');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  bool isLocationEnabled = false;

  set setLocationPermission(bool value) {
    isLocationEnabled = value;
    update();
  }
}
