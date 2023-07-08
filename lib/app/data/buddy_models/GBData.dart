// To parse this JSON data, do
//
//     final geocodeBuddy = geocodeBuddyFromJson(jsonString);

import 'dart:convert';

GeocodeBuddy geocodeBuddyFromJson(String str) => GeocodeBuddy.fromJson(json.decode(str));

String geocodeBuddyToJson(GeocodeBuddy data) => json.encode(data.toJson());

class GeocodeBuddy {
  GeocodeBuddy({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.placeRank,
    this.category,
    this.type,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
    this.address,
    this.boundingbox,
  });

  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  int? placeRank;
  String? category;
  String? type;
  double? importance;
  String? addresstype;
  dynamic? name;
  String? displayName;
  Address? address;
  List<String>? boundingbox;

  factory GeocodeBuddy.fromJson(Map<String, dynamic> json) => GeocodeBuddy(
    placeId: json["place_id"],
    licence: json["licence"],
    osmType: json["osm_type"],
    osmId: json["osm_id"],
    lat: json["lat"],
    lon: json["lon"],
    placeRank: json["place_rank"],
    category: json["category"],
    type: json["type"],
    importance: json["importance"].toDouble(),
    addresstype: json["addresstype"],
    name: json["name"],
    displayName: json["display_name"],
    address: Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "place_id": placeId,
    "licence": licence,
    "osm_type": osmType,
    "osm_id": osmId,
    "lat": lat,
    "lon": lon,
    "place_rank": placeRank,
    "category": category,
    "type": type,
    "importance": importance,
    "addresstype": addresstype,
    "name": name,
    "display_name": displayName,
    "address": address?.toJson(),
  };
}

class Address {
  Address({
    this.residential,
    this.suburb,
    this.city,
    this.state,
    this.iso31662Lvl4,
    this.postcode,
    this.country,
    this.countryCode,
  });

  String? residential;
  String? suburb;
  String? city;
  String? state;
  String? iso31662Lvl4;
  String? postcode;
  String? country;
  String? countryCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    residential: json["residential"],
    suburb: json["suburb"],
    city: json["city"],
    state: json["state"],
    iso31662Lvl4: json["ISO3166-2-lvl4"],
    postcode: json["postcode"],
    country: json["country"],
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "residential": residential,
    "suburb": suburb,
    "city": city,
    "state": state,
    "ISO3166-2-lvl4": iso31662Lvl4,
    "postcode": postcode,
    "country": country,
    "country_code": countryCode,
  };
}