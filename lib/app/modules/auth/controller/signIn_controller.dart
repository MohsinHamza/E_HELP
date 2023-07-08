import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/auth/controller/auth_controller.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';

class SignInController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController emailC = TextEditingController();

  final TextEditingController passwordC = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();
  bool _isObsecure = false;

  validate() async {

    //Focus.of(Get.context!).unfocus();
    if (formKey.currentState?.validate() ?? false) {

      AuthState authState = await authController.signInWithEmailPassword(
          emailC.text, passwordC.text);
      if (authState == AuthState.SIGNEDINSUCESS) {
        Get.toNamed(Routes.HOME);
      }else{
        print(authState);
      }
    }
  }

//Getter setters below exists...
  bool get isObsecure => _isObsecure;

  set isObsecure(bool value) {
    _isObsecure = value;
    update();
  }
}
