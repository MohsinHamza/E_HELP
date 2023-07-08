import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class FirebasePath {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  //********************Document Paths
  static DocumentReference users(String useruid) => userC.doc(useruid);

  static DocumentReference emergencyContact(String useruid, String docId) => emergencyContactsC(useruid).doc(docId);

  static DocumentReference paidContact(String useruid, String docId) => paidContactsC(useruid).doc(docId);

  static DocumentReference emergencyAlert(String useruid) => emergencyAlertC.doc(useruid);

  static DocumentReference invitedBy(String useruid) => _invitedByC(useruid).doc("invitedBy");

  //********************collection reference paths
  static CollectionReference feedback() => db.collection('feedback');
  static CollectionReference userC = db.collection('users');

  static DocumentReference signedUpOnMyInvitation(String invitedByUid, String userId) => userC.doc(userId).collection("signedOnMyInvitation").doc
    (invitedByUid);
  static CollectionReference invitedByDiscountC(String userId) => userC.doc(userId).collection("discounts");
  static CollectionReference emergencyAlertC = db.collection("emergency");
  static CollectionReference emailC = db.collection("messages");

  static CollectionReference emergencyContactsC(String useruid) => db.collection("users").doc(useruid).collection("emergencyContacts");

  static CollectionReference priceListC() => db.collection("prices");

  static CollectionReference _invitedByC(String useruid) => db.collection("users").doc(useruid).collection("InvitedBy");

  static CollectionReference paidContactsC(String useruid) => db.collection("users").doc(useruid).collection("paidContacts");
}

class StoragePath {
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Reference userAvatar(String useruid) => storage.ref().child("users/$useruid/avatar.png");

  static Reference userImages(String useruid, String filePath) =>
      storage.ref().child("users/$useruid/userImages/${p.basename(filePath)}");
  static Reference userIdImages(String useruid, String filePath) =>
      storage.ref().child("users/$useruid/IdImages/${p.basename(filePath)}");
  static Reference userEvidenceImages(String useruid, String filePath) =>
      storage.ref().child("users/$useruid/userEvidenceImages/${p.basename(filePath)}");
}