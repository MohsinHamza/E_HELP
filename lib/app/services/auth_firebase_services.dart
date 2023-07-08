import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../utils/firebasepaths.dart';
import '../controllers/my_app_user.dart';
import '../data/local/dynamic_link_payload_model.dart';

abstract class AuthService {
  Future<MyAppUser?> signUpWithEmailPassword({required MyAppUser myAppUser, required password, DynamicLinkPayloadModel? payload});

  Future<MyAppUser?> signInWithEmailPassword({required email, required password});

  bool? isUserEmailVerified();

  Stream<MyAppUser?> get authStateChanges;

  Future<void> sendEmailVerification();

  Future<void> signOut();
}

class FirebaseAuthService extends GetxService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  Future<MyAppUser?> signInWithEmailPassword({required email, required password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print('User Exception: ' + e.toString());
      rethrow;
    }
  }

  @override
  Future<MyAppUser?> signUpWithEmailPassword({required myAppUser, required password, DynamicLinkPayloadModel? payload}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: myAppUser.email!, password: password);
      myAppUser.id = userCredential.user!.uid;
      myAppUser.createdAt = DateTime.now().millisecondsSinceEpoch;
      myAppUser.updatedAt = DateTime.now().millisecondsSinceEpoch;
      createUserCollection(myAppUser, payload: payload);
      return myAppUser;
    } catch (e) {
      print('User Exception: ' + e.toString());
      rethrow;
    }
  }

  Future createUserCollection(MyAppUser myAppUser, {DynamicLinkPayloadModel? payload}) async {
    try {
      print(myAppUser.toMap());
      Logger().d(payload?.toJson());
      myAppUser.guardianUid = payload?.guardianUid;
      await FirebasePath.users(FirebaseAuth.instance.currentUser!.uid).set(myAppUser.toMap());
      await FirebasePath.invitedBy(FirebaseAuth.instance.currentUser!.uid).set(payload?.toJson());
    } catch (e) {
      print("err occured at createUserCollection ");
      Logger().e(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //returns true if expired.... [pre condition is expirydate should not be null]
  Future<bool?> isSubscriptionExpired(int? expireMilliseconds) async {
    if (expireMilliseconds == null) return null;
    try {
      DateTime expireDate = DateTime.fromMillisecondsSinceEpoch(expireMilliseconds);
      return DateTime.now().isAfter(expireDate);
    } catch (e) {
      debugPrint("err occured at isSubscriptionExpired ");
      Logger().e(e.toString());
    }

    return null;
  }

  @override
  Stream<MyAppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  /// private method to create `User` from `FirebaseUser`
  MyAppUser? _userFromFirebase(User? user) {
    if (user != null) {
      MyAppUser myAppUser = MyAppUser();
      myAppUser.id = user.uid;
      return myAppUser;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
    print("***EMAIL OTP SENT***");
  }

  @override
  bool? isUserEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified;
  }
}