import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../data/local/country_model.dart';

class CountryServices extends GetxService {
  static CountryServices get find => CountryServices();
  List<LocalCountryModel> countryList = [];

  update(List<LocalCountryModel> countries){
    print("updating countries ${countries.length}");
    this.countryList = countries;
  }
  Future<List<LocalCountryModel>> getCountries() async {
    if (countryList.isEmpty) {
      List<LocalCountryModel> _countries = await _getCountries();
      countryList = _countries;
      // countryList = countries.map((e) => e.name).toList();
    }
    return countryList;
  }

  Future<List<LocalCountryModel>> _getCountries() async {
    List<LocalCountryModel> _countries =  countryModelFromJson(await rootBundle.loadString('assets/json/country_codes.json'));
    return _countries;
  }
}