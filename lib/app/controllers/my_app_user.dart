import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/services/firebase_storage_services.dart';

import '../routes/app_pages.dart';
import '../services/FirebaseFirestoreServices.dart';

class MyAppUser extends GetxService {
  static MyAppUser get find => Get.find();

  String? id;
  String? username;
  String? name;
  String? about;
  String? phonenumber;
  String? stripeId;

  String? email; // on reset password page, this field can be null
  String? address;
  String? profileurl;
  double? lat;
  double? lng;
  int? dob;
  String? guardianUid;
  bool? isSubscriptionExpired;
  String? subscriptionExpiryMilliseconds;
  int? createdAt;
  int? updatedAt;
  String? countryCode;

  MyAppUser();


  update(MyAppUser user) {
    id = user.id;
    stripeId = user.stripeId;
    username = user.username;
    dob = user.dob;
    stripeId = user.stripeId;
    name = user.name;
    about = user.about;
    email = user.email;
    address = user.address;
    profileurl = user.profileurl;
    phonenumber = user.phonenumber;
    lat = user.lat;
    lng = user.lng;
    isSubscriptionExpired = user.isSubscriptionExpired;
    guardianUid = user.guardianUid;
    createdAt = user.createdAt;
    updatedAt = user.updatedAt;
    countryCode = user.countryCode;
print("After update: ${toMap()}");
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      "stripeId" : stripeId,
      'name': name.toString(),
      'about': about,
      'phone': phonenumber,
      'email': email,
      'address': address,
      'profileurl': profileurl,
      'lat': lat,
      'lng': lng,
      'dob': dob,
      "guardianId": guardianUid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastUpdated' : updatedAt,
      'username': username,
      'countryCode': countryCode,

      'isSubscriptionExpired': isSubscriptionExpired,
      "subscriptionExpiryMilliseconds" : subscriptionExpiryMilliseconds,
    };
  }

  MyAppUser.fromMap(map, {String? userId})
      : id = userId ?? map['userId'] ?? '',
        name = map['name'],
        countryCode = map['countryCode'] ?? "us",
        stripeId = map["stripeId"],
        username = map['username'],
        dob = map['dob'],
        about = map['about'],
        phonenumber = map['phone'],
        email = map['email'],
        address = map['address'],
        profileurl = map['profileurl'],
        lat = map['lat'],
        lng = map['lng'],
        guardianUid = map['guardianId'],
        isSubscriptionExpired  = map['isSubscriptionExpired'],
        subscriptionExpiryMilliseconds = map['subscriptionExpiryMilliseconds'].toString(),
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'];

  MyAppUser.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), userId: snapshot.reference.id);

  Future<void> signOut() async {
    Get.offAllNamed(Routes.LOGIN);

    await FirebaseAuth.instance.signOut();
  }
}
