import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';
import 'package:getx_skeleton/app/services/location_services.dart';
import 'package:getx_skeleton/app/services/logger_services.dart';
import 'package:location/location.dart';

class TransactionAlertController extends GetxController with GetSingleTickerProviderStateMixin implements GetxService {
  static TransactionAlertController get to => Get.find();
  //late final AnimationController animationController;
  final LocationServices locationServices = Get.find();
  StreamSubscription? locationSubscription;

  bool _isAnimating = false;
  RxBool isAlertSent = false.obs;
  double _lat = 0;
  double _lng = 0;

  @override
  onInit() {
    super.onInit();
    //animationController = AnimationController(vsync: this);
    getUserLocation();
  }

  RxString alertType = "ambulance".obs;
  RxString emergencyType = "fire".obs;
  RxString whoNeedsHelp = "me".obs;
  // List<String> emergencyItemList = [
  //   "ambulance",
  //   "firebrigade",
  //   "police",
  //   "coast guard"
  // ];
  void onEmergencyTypeTap(String type) async {
    alertType.value = type.toLowerCase();
    print('alertType: ${alertType.value}');
    update();
    await Get.toNamed(Routes.EMERGENCYTYPE);
  }

  int endTim = 0;

  ///Work starts from here...
  Future<void> startButtonAnimation(String alertString) async {
    if (isAnimating) return;
    isAlertSent.value = true;
    alertType.value = alertString;
    isAnimating = true;
    endTim = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
    sendToFirebase();

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (timer.tick == 2) {
        Get.toNamed(
          Routes.RECORDEVIDENCE,
        );
        isAnimating = false;
      }
    });
  }

  void startLocationStream() {
    try {
      locationServices.location.getLocation().then((value) => FirebaseFirestoreService.find.updateLatLngAsStream(alertType: alertType.value, lat: value.latitude ?? _lat, lng: value.longitude ?? _lng, isStreamActive: false));
      locationSubscription = locationServices.getStreamedLocation.handleError((onError) {
        debugPrint(onError.toString());
        locationSubscription?.cancel();
        closeStream();
      }).listen((eventData) {
        if (eventData.longitude != _lng && eventData.latitude != _lat) {
          _lat = eventData.latitude ?? 0;
          _lng = eventData.longitude ?? 0;
          FirebaseFirestoreService.find.updateLatLngAsStream(alertType: alertType.value, lat: _lat, lng: _lng, isStreamActive: true);
        } else {
          debugPrint("same lat lng so not updating it to firebase");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      closeStream();
    }
  }

  ///closes the stream
  closeStream() {
    print("closes Stream");
    FirebaseFirestoreService.find.updateLatLngAsStream(alertType: alertType.value, lat: _lat, lng: _lng, isStreamActive: false);
  }

  ///starts stream and send data to firebase.
  Future<void> sendToFirebase() async {
    await getUserLocation();
    await FirebaseFirestoreService.find.sendAlert();
    startLocationStream();
  }

  Future<void> getUserLocation() async {
    try {
      LocationData locationData = await locationServices.location.getLocation();
      MyAppUser myAppUser = MyAppUser.find;
      myAppUser.lat = locationData.latitude;
      myAppUser.lng = locationData.longitude;
      MyAppUser.find.update(myAppUser);
    } catch (e) {
      LoggerServices.find.logError(e);
    }
  }

  bool get isAnimating => _isAnimating;

  set isAnimating(bool value) {
    _isAnimating = value;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    closeStream();
  }

  @override
  void onClose() {
    super.onClose();
    closeStream();
  }
}

class TransactionAlertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionAlertController>(
      () => TransactionAlertController(),
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
    forEach((element) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    });

    return result;
  }
}
