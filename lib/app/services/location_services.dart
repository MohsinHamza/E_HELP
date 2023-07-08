import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationServices extends GetxService {
  final Location location = Location();

  LocationServices() {
    location.changeSettings(interval: 3000, distanceFilter: 10);
  }

   get getStreamedLocation => location.onLocationChanged.distinct();
}