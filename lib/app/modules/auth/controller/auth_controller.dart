import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/base_controller.dart';
import 'package:getx_skeleton/app/modules/auth/controller/signIn_controller.dart';
import 'package:getx_skeleton/app/modules/auth/controller/signUp_controller.dart';
import 'package:getx_skeleton/utils/constants.dart';
import 'package:getx_skeleton/utils/firebasepaths.dart';

import '../../../controllers/my_app_user.dart';
import '../../../data/local/dynamic_link_payload_model.dart';
import '../../../services/FirebaseFirestoreServices.dart';
import '../../../services/auth_firebase_services.dart';

enum AuthState {
  INITIAL,
  INPROGRESS,
  SIGNEDINSUCESS,
  SIGNEDINFAIL,
  REGISTRATIONSUCESS,
  REGISTRATIONFAIL,
}

class AuthController extends BaseController {
  String? errorMessage;
  final FirebaseAuthService _authService = Get.find<FirebaseAuthService>();
  final FirebaseFirestoreService _firestoreService = Get.find<FirebaseFirestoreService>();

  Stream<MyAppUser?> get authStateChanges => _authService.authStateChanges;

  Future<AuthState> signUpWithEmailPassword(MyAppUser myAppUser, String password, {DynamicLinkPayloadModel? payload}) async {
    clearErrorMessage();
    setState(ViewState.Busy);

    try {
      MyAppUser? user = await _authService.signUpWithEmailPassword(myAppUser: myAppUser, password: password, payload: payload);

      if (user == null) {
        errorMessage = Constants.failedToSignup;
        setState(ViewState.Idle);
        return AuthState.REGISTRATIONFAIL;
      }




      Get.find<MyAppUser>().update(user);
      ///todo: send email verification from here
      //sendEmailVerification();
      return AuthState.REGISTRATIONSUCESS;

    } on FirebaseException catch (e) {
      print('User Exception: ' + e.code);
      setState(ViewState.Idle);
      errorMessage = e.message;
      return AuthState.REGISTRATIONFAIL;
    } catch (E) {
      print(E);
      errorMessage = "Something went wrong!";
      return AuthState.REGISTRATIONFAIL;
    }
  }

  Future<AuthState> signInWithEmailPassword(String email, String password) async {
    setState(ViewState.Busy);
    MyAppUser? user;
    try {
      clearErrorMessage();
      print('***signInWithEmailPassword***');
      user = await _authService.signInWithEmailPassword(email: email, password: password);
      debugPrint('***signInWithEmailPassword***');
      if (user == null) {
        errorMessage = Constants.emailORpasswordIncorrect;
        setState(ViewState.Idle);
        return AuthState.REGISTRATIONFAIL;
      }
      final myuser = await _firestoreService.loadMyAppUserData(user.id.toString());

      debugPrint('user email verified and update');

      debugPrint('userid: ' + myuser.id.toString());
      Get.find<MyAppUser>().update(myuser);
      setState(ViewState.Idle);

      return AuthState.SIGNEDINSUCESS;
    } on FirebaseException catch (e) {
      print(e);
      setState(ViewState.Idle);

      errorMessage = e.message ?? "Something went wrong, please try again later.";
      return AuthState.SIGNEDINFAIL;
    } catch (e) {
      print(e);
      errorMessage = "Something went wrong, please try again later.";

      return AuthState.SIGNEDINFAIL;
    }
  }

  Future<void> sendEmailVerification() => _authService.sendEmailVerification();

  // void doNavigation() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   try {
  //     if (user != null) {
  //       MyAppUser? myAppUser =
  //       await FirebaseFirestoreService.find.loadMyAppUserData(user.uid);
  //       MyAppUser.find.update(myAppUser);
  //       Get.offAllNamed(Routes.HOME);
  //     } else {
  //       Get.offAllNamed(Routes.LOGIN);
  //     }
  //   } catch (e) {
  //     Get.offAllNamed(Routes.LOGIN);
  //     Logger().e(e);
  //   }
  // }

  clearErrorMessage() {
    errorMessage = null;
    update();
  }
}

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}