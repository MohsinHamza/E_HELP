import 'package:google_maps_flutter/google_maps_flutter.dart';

class GroupModel {
  String name;
  List<CustomContactModel>? members;
  String createdAt;
  bool isActive;
  GroupModel({
    this.name = '',
    this.createdAt = '',
    this.isActive = false,
    this.members,
  });
  static GroupModel fromMap(Map data) {
    List<CustomContactModel> members = [];
    if (data['members'] != null && data['members'].isNotEmpty) {
      members = data['members'];
    }
    return GroupModel(
        name: data['name'],
        createdAt: data['createdAt'],
        isActive: data['isActive'],
        members: members);
  }
}

class CustomContactModel {
  String name;
  LatLng position;
  String marker;
  String image;
  CustomContactModel(
      {required this.name,
      required this.position,
      required this.image,
      required this.marker});
  static CustomContactModel fromMap(Map data) {
    return CustomContactModel(
      name: data['name'],
      position: data['position'],
      marker: data['marker'],
      image: data['image'],
    );
  }
}
