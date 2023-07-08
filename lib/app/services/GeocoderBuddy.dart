


import '../data/buddy_models/GBData.dart';
import '../data/buddy_models/GBLatLng.dart';
import '../data/buddy_models/GBSearchData.dart';
import 'NetworkService.dart';

class GeocoderBuddy {


  static Future<GeocodeBuddy> searchToGBData(GBSearchData data) async {
    var pos =
        GBLatLng(lat: double.parse(data.lat), lng: double.parse(data.lon));
    var res = await GeocodeServices.getDetails(pos);
    return res;
  }

  static Future<GeocodeBuddy> findDetails(GBLatLng pos) async {
    var data = await GeocodeServices.getDetails(pos);
    return data;
  }
}