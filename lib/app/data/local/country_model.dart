import 'dart:convert';

List<LocalCountryModel> countryModelFromJson(String str) => List<LocalCountryModel>.from(json.decode(str).map((x) => LocalCountryModel.fromJson(x)));

String countryModelToJson(List<LocalCountryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocalCountryModel {
  LocalCountryModel({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  String name;
  String dialCode;
  String code;

  factory LocalCountryModel.fromJson(Map<String, dynamic> json) => LocalCountryModel(
        name: json["name"],
        dialCode: json["dial_code"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "dial_code": dialCode,
        "code": code,
      };
}