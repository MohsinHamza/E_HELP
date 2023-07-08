import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/app/data/buddy_models/GBData.dart';
import 'package:getx_skeleton/app/data/buddy_models/GBLatLng.dart';
import 'package:getx_skeleton/app/data/local/invited_contact.dart';
import 'package:getx_skeleton/app/data/local/price_model.dart';
import 'package:getx_skeleton/utils/DateFormate_utils.dart';

import '../../utils/debounder_helper.dart';
import '../../utils/firebasepaths.dart';
import '../data/models/contact_model.dart';
import '../modules/feeback_screen/feedback_Screen.dart';
import '../modules/nav_emergency/controllers/transaction_alert_controller.dart';
import 'GeocoderBuddy.dart';
import 'logger_services.dart';

abstract class FirestoreService {
  // Future<void> updateToken(String token);

  Future<MyAppUser> loadMyAppUserData(String uid);

  Future<void> sendAlert();

  Future<void> updateLatLngAsStream(
      {required String alertType, required double lat, required double lng});

  //Send Noti to admin
  Future<void> updateMyAppUserLocation(double? lat, double? lng);

  //Paid Contacts Operations...
  // ..*******************************************************************************************************************************
  Future<List<ContactModel>?> getPaidContacts();

  Future<DocumentReference<Object?>?> addPaidContact(ContactModel contactModel);

  Future<bool> updatePaidContact(ContactModel contactModel);

  Future<bool> deletePaidContact(ContactModel contactModel);

  //Emergency Contacts Operations
  // ..*******************************************************************************************************************************
  Future<List<ContactModel>?> getEmergencyContacts();

  Future<List<PriceModel>> getPriceList();

  Future<DocumentReference<Object?>?> addEmergencyContact(
      ContactModel contactModel);

  Future<bool> updateEmergencyContact(ContactModel contactModel);

  Future<bool> deleteEmergencyContact(ContactModel contactModel);

  Future<bool> sendEmail({required String toNumber, required String message});

  Future<bool> updateProfilePicture({required String url});

  Future<bool> updatePhoneNumber({required String newPhoneNumber});

  Future<bool> updateSubscriptionStatus({required String? days});

  // Search Operations *******************************
  Future<List<ContactModel>> searchEmergencyContactUser(String query);

  Future<List<ContactModel>> searchPaidContactUser(String query);

  void submitFeedback(FeedbackModel feedback);

  //discount work below
  void invitedByEntry(InvitedContactModel? model);

  Future<bool> isDiscountEligible();

  Future<void> discountRemove();
//discount work below ended here....
}

class FirebaseFirestoreService extends GetxService implements FirestoreService {
  static FirebaseFirestoreService get find =>
      Get.find<FirebaseFirestoreService>();
  MyAppUser user = Get.find<MyAppUser>();

  // @override
  // Future<void> updateToken(String token) async {
  //   await FirebasePath.users(FirebaseAuth.instance.currentUser?.uid ?? "").set({
  //     "token": token,
  //   }, SetOptions(merge: true));
  // }

  @override
  Future<MyAppUser> loadMyAppUserData(String uid) async {
    LoggerServices.find.log('loadMyAppUserData: ' + uid.toString());
    final snapshot = await FirebasePath.users(uid).get();
    MyAppUser user = MyAppUser.fromSnapshot(snapshot);
    return user;
  }

  @override
  Future<void> updateMyAppUserLocation(double? lat, double? lng,
      {bool isStreamActive = false}) async {
    if (lat != null && lng != null) {
      await FirebasePath.users(user.id!).set({
        "lat": lat,
        "lng": lng,
      }, SetOptions(merge: true));
    }
  }

  //Emergency Operations...
  // ..*******************************************************************************************************************************
  @override
  Future<List<ContactModel>?> getEmergencyContacts() async {
    final snapshot = await FirebasePath.emergencyContactsC(user.id ?? "").get();
    List<ContactModel>? contacts = snapshot.docs.map((doc) {
      return ContactModel.fromSnapshot(doc);
    }).toList();
    return contacts;
  }

  @override
  Future<List<PriceModel>> getPriceList() async {
    List<PriceModel> prices = [];
    try {
      final snapshot = await FirebasePath.priceListC().get();
      var data = await snapshot.docs;
      debugPrint("Getting data for pricec list");

      for (var doc in data) {
        prices.add(
            PriceModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id));
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return prices;
  }

  @override
  Future<List<ContactModel>> searchEmergencyContactUser(String query) async {
    try {
      final querySnapshot = await FirebasePath.emergencyContactsC(user.id ?? "")
          .orderBy('name')
          .startAt([query.toUpperCase()])
          .endAt([query.toLowerCase()])
          .limit(5)
          .get();

      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      final paidUserList =
          docs.map((doc) => ContactModel.fromSnapshot(doc)).toList();

      //remove duplicate
      final ids = paidUserList.map((org) => org.name).toSet();
      paidUserList.retainWhere((org) => ids.remove(org.name));
      return paidUserList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Future<List<ContactModel>> searchPaidContactUser(String query) async {
    try {
      final querySnapshot = await FirebasePath.paidContactsC(user.id ?? "")
          .orderBy('name')
          .startAt([query])
          .endAt([query + "\uf8ff"])
          .limit(5)
          .get();

      List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      final paidUserList =
          docs.map((doc) => ContactModel.fromSnapshot(doc)).toList();

      //remove duplicate
      final ids = paidUserList.map((org) => org.name).toSet();
      paidUserList.retainWhere((org) => ids.remove(org.name));
      return paidUserList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Future<DocumentReference<Object?>?> addEmergencyContact(
      ContactModel contactModel) async {
    try {
      final snapshot = await FirebasePath.emergencyContactsC(user.id ?? "")
          .add(contactModel.toJson());

      return snapshot;
    } catch (e) {
      LoggerServices.find.logError('addEmergencyContact: ' + e.toString());
    }
    return null;
  }

  @override
  Future<bool> updateEmergencyContact(ContactModel contactModel) async {
    bool isSuccess = false;
    try {
      print(contactModel.docId.toString() +
          " docId updateEmergencyContact <<<<<<<<<<<=");
      await FirebasePath.emergencyContact(
              user.id ?? "", contactModel.docId ?? "")
          .update(contactModel.toJson());
      isSuccess = true;
    } catch (e) {
      LoggerServices.find.logError(
          'updateEmergencyContact: ' + contactModel.toJson().toString());
      isSuccess = false;
      LoggerServices.find.logError('updateEmergencyContact: ' + e.toString());
    }
    return isSuccess;
  }

  @override
  Future<bool> deleteEmergencyContact(ContactModel contactModel) async {
    bool isSuccess = false;
    try {
      print(contactModel.docId.toString() +
          " docId deleteEmergencyContact <<<<<<<<<<<=");
      await FirebasePath.emergencyContact(
              user.id ?? "", contactModel.docId ?? "")
          .delete();
      isSuccess = true;
    } catch (e) {
      LoggerServices.find.logError(
          'deleteEmergencyContact: ' + contactModel.toJson().toString());
      isSuccess = false;
      LoggerServices.find.logError('deleteEmergencyContact: ' + e.toString());
    }
    return isSuccess;
  }

//Paid Contact Operations...
// ..*******************************************************************************************************************************
  @override
  Future<List<ContactModel>?> getPaidContacts() async {
    final snapshot = await FirebasePath.paidContactsC(user.id ?? "").get();
    List<ContactModel>? contacts = snapshot.docs.map((doc) {
      return ContactModel.fromSnapshot(doc);
    }).toList();
    return contacts;
  }

  @override
  Future<DocumentReference<Object?>?> addPaidContact(
      ContactModel contactModel) async {
    try {
      final snapshot = await FirebasePath.paidContactsC(user.id ?? "")
          .add(contactModel.toJson());

      return snapshot;
    } catch (e) {
      LoggerServices.find.logError('addPaidContact: ' + e.toString());
    }
    return null;
  }

  @override
  Future<bool> updatePaidContact(ContactModel contactModel) async {
    bool isSuccess = false;
    try {
      print(contactModel.docId.toString() +
          " docId updateEmergencyContact <<<<<<<<<<<=");
      await FirebasePath.paidContact(user.id ?? "", contactModel.docId ?? "")
          .update(contactModel.toJson());
      isSuccess = true;
    } catch (e) {
      LoggerServices.find.logError(
          'updateEmergencyContact err: ' + contactModel.toJson().toString());
      isSuccess = false;
      LoggerServices.find
          .logError('updateEmergencyContact actual case = > ' + e.toString());
    }
    return isSuccess;
  }

  @override
  Future<bool> deletePaidContact(ContactModel contactModel) async {
    bool isSuccess = false;
    try {
      print(contactModel.docId.toString() +
          " docId deleteEmergencyContact <<<<<<<<<<<=");
      await FirebasePath.paidContact(user.id ?? "", contactModel.docId ?? "")
          .delete();
      isSuccess = true;
    } catch (e) {
      LoggerServices.find.logError(
          'deleteEmergencyContact: ' + contactModel.toJson().toString());
      isSuccess = false;
      LoggerServices.find.logError('deleteEmergencyContact: ' + e.toString());
    }
    return isSuccess;
  }

  final Debouncer locationDebouncer = Get.find<Debouncer>();

  ///constantly update the user data.
  @override
  Future<void> updateLatLngAsStream(
      {required double lat,
      required double lng,
      required String alertType,
      bool isStreamActive = false}) async {
    print("updating firebase stream here with stream: $isStreamActive");
    if (lat == 0 || lng == 0) return;
    if (FirebaseAuth.instance.currentUser != null) {
      locationDebouncer.debounce(() async {
        print(
            'emergencyId: ${FirebasePath.emergencyAlert(FirebaseAuth.instance.currentUser!.uid).id}');
        await FirebaseFirestore.instance
            .collection("emergency")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "lat": lat,
          'alertType': Get.find<TransactionAlertController>().alertType.value,
          'who': Get.find<TransactionAlertController>().whoNeedsHelp.value,
          'emergencyType':
              Get.find<TransactionAlertController>().emergencyType.value,
          "name": user.name ?? user.username,
          "picture": user.profileurl,
          "email": user.email,
          "phone": user.phonenumber,
          "lng": lng,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
          "lastUpdated": DateTime.now().millisecondsSinceEpoch,
          "isActive": isStreamActive
        }, SetOptions(merge: true));
        // FirebasePath.emergencyAlert(FirebaseAuth.instance.currentUser!.uid)
        //     .set({
        //   "lat": lat,
        //   'alertType': Get.find<TransactionAlertController>().alertType.value,
        //   'who': Get.find<TransactionAlertController>().whoNeedsHelp.value,
        //   'emergencyType':
        //       Get.find<TransactionAlertController>().emergencyType.value,
        //   "name": user.name ?? user.username,
        //   "picture": user.profileurl,
        //   "email": user.email,
        //   "phone": user.phonenumber,
        //   "lng": lng,
        //   'updatedAt': DateTime.now().millisecondsSinceEpoch,
        //   "lastUpdated": DateTime.now().millisecondsSinceEpoch,
        //   "isActive": isStreamActive
        // }, SetOptions(merge: true));
      });
    } else {
      LoggerServices.find.logError("updateLatLngAsStream: currentUser is null");
    }
  }

  @override
  Future<void> sendAlert() async {
    ///IS RESCUED IS BY DEFAULT FALSE AND WHEN DELETING THE DOC, IM TAKING ISRESUCED FROM THE DOC AND SETTING IT TO STORED VARIABLE
    ///SO THAT I WONT LOST THE TRACK OF THE RESCUED STATUS OF THE USER WHEN THE DOC IS DELETED.
    user.createdAt = DateTime.now().millisecondsSinceEpoch;
    user.updatedAt = DateTime.now().millisecondsSinceEpoch;
    bool _isRescued = false;
    try {
      // print("htting geobuyddy ... ${user.updatedAt}");
      GeocodeBuddy geocodeData = await GeocoderBuddy.findDetails(
          GBLatLng(lat: user.lat ?? 0, lng: user.lng ?? 0));
      // print(geocodeData.address?.toJson());
      user.address = geocodeData.address?.toJson().toString() ?? "";
    } catch (e) {
      print("err occured at geobuddy");
      print(e);
    }
    //DONE THIS FOR CLOUD FUNCTIONS>>>

    await FirebasePath.emergencyAlert(user.id ?? "").get().then((snap) async {
      ///IF exists delete it and then set as new.. becuase notification issue.
      if (snap.data() != null) {
        var _snapData = snap.data() as Map<String, dynamic>;
        //get value of isRescued if its 6 hours within .
        if (CustomeDateFormate.isSixHoursAgo(_snapData['createdAt'])) {
          _isRescued = _snapData['isRescued'] ?? false;
        }
        await FirebasePath.emergencyAlert(user.id ?? "").delete();
      }
      Map<String, dynamic> _data = user.toMap();
      _data['isRescued'] = _isRescued;
      _data['alertType'] =
          Get.find<TransactionAlertController>().alertType.value;
      _data['who'] = Get.find<TransactionAlertController>().whoNeedsHelp.value;
      _data['emergencyType'] =
          Get.find<TransactionAlertController>().emergencyType.value;

      print('_data: $_data');

      ///todo: change it to set
      // await FirebasePath.emergencyAlert(user.id!).set(_data);
      await FirebaseFirestore.instance
          .collection("emergency")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(_data);
    });
  }

  @override
  void submitFeedback(FeedbackModel feedback) {
    FirebasePath.feedback().add(feedback.toMap());
  }

  @override
  Future<bool> sendEmail(
      {required String toNumber, required String message}) async {
    bool isSuccess = false;
    try {
      await FirebasePath.emailC.add({"to": toNumber, "body": message});
      isSuccess = true;
    } catch (e) {
      LoggerServices.find.logError('sendEmail: ' + e.toString());
      isSuccess = false;
    }
    return isSuccess;
  }

  @override
  Future<bool> updatePhoneNumber({required String newPhoneNumber}) async {
    bool isSuccess = false;
    try {
      await FirebasePath.users(FirebaseAuth.instance.currentUser!.uid)
          .set({"phone": newPhoneNumber}, SetOptions(merge: true));
      isSuccess = true;
    } catch (e) {
      print(e);
    }
    return isSuccess;
  }

  @override
  Future<bool> updateProfilePicture({required String url}) async {
    bool isSuccess = false;
    try {
      await FirebasePath.users(FirebaseAuth.instance.currentUser!.uid)
          .set({"profileurl": url}, SetOptions(merge: true));
      isSuccess = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return isSuccess;
  }

  @override
  Future<bool> updateSubscriptionStatus(
      {required String? days, bool isExpired = false}) async {
    bool isSuccess = false;
    try {
      // user.isSubscriptionActive = true;
      user.isSubscriptionExpired = isExpired;

      user.update(user);
      await FirebasePath.users(FirebaseAuth.instance.currentUser!.uid).set({
        "isSubscriptionExpired": isExpired,
        "subscriptionExpiryMilliseconds": days,
        // days == null
        //     ? days
        //     : DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch,
      }, SetOptions(merge: true));
      isSuccess = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return isSuccess;
  }

  Future<bool> updateName({required String url}) async {
    bool isSuccess = false;
    try {
      await FirebasePath.users(FirebaseAuth.instance.currentUser!.uid)
          .set({"name": url}, SetOptions(merge: true));
      isSuccess = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return isSuccess;
  }

  Future<bool> updateDOB({required int? url}) async {
    bool isSuccess = false;
    try {
      await FirebasePath.users(FirebaseAuth.instance.currentUser!.uid)
          .set({"dob": url}, SetOptions(merge: true));
      isSuccess = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return isSuccess;
  }

  @override
  void invitedByEntry(InvitedContactModel? model) async {
    if (model == null) return;
    try {
      //my doc
      // model.type = "I_signedUpOnInvitation";
      // userC.doc(userId).collection("signedOnMyInvitation").doc
      //   (invitedByUid)
      // await FirebasePath.signedUpOnMyInvitation(model.invitedBy, user.id ?? "")// 1.invitedByUid 2.userId
      //     .set({'invitedBy': model.invitedBy, "expiryMillis": model.expiryMillis,"type":model.type});

      //invited by doc

      model.type = 'redeemedBy';
      await FirebasePath.signedUpOnMyInvitation(user.id ?? "", model.invitedBy)
          .set({'invitedBy': user.id!, "expiryMillis": model.expiryMillis,"type":model.type});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<bool> isDiscountEligible() async {
    bool isEligible = false;
    try {
      var detail = await FirebasePath.invitedByDiscountC(user.id ?? "").get();
      isEligible = detail.size > 0;
    } catch (e) {
      debugPrint(e.toString());
    }
    return isEligible;
  }

  @override
  //removes first entry from discounts....
  Future<void> discountRemove() async {
    try {
      var docId =
          await FirebasePath.invitedByDiscountC(user.id ?? "").limit(1).get();
      if (docId.size > 0) {
        await FirebasePath.invitedByDiscountC(user.id ?? "")
            .doc(docId.docs.first.id)
            .delete();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
