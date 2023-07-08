import 'package:http/http.dart' as http;

import '../data/buddy_models/GBData.dart';
import '../data/buddy_models/GBLatLng.dart';
import '../data/buddy_models/MapData.dart';

const PATH = "https://nominatim.openstreetmap.org";

class GeocodeServices {
  static Future<List<MapData>> searhAddress(String query) async {
    var request = http.Request('GET', Uri.parse("$PATH/search?q=$query&format=jsonv2"));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return mapDataFromJson(data);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<GeocodeBuddy> getDetails(GBLatLng pos) async {
    var request = http.Request('GET', Uri.parse('$PATH/reverse?lat=${pos.lat}&lon=${pos.lng}&format=jsonv2'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      return geocodeBuddyFromJson(data);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}