import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/base_controller.dart';
import 'package:getx_skeleton/app/components/reuseable_button.dart';
import 'package:getx_skeleton/app/modules/auth/controller/auth_controller.dart';
import 'package:getx_skeleton/app/modules/auth/controller/signIn_controller.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';
import 'package:logger/logger.dart';

import '../../../config/assets/svg_assets.dart';
import '../../../config/theme/apptextstyles.dart';
import 'components/already_have_an_account_check.dart';

import 'components/visibility_icon.dart';

class LoginScreen extends GetView<SignInController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: controller.formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icons/men_logo.png',),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Welcome Back!',
                      style: AppTextStyles.kPrimaryTitle,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      'Please enter your account here',
                      style: AppTextStyles.kPrimaryS2W4,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 56,
                      child: TextFormField(
                        validator: (_) {
                          if (!GetUtils.isEmail(_ ?? "")) {
                            return "Please Enter Valid Email";
                          } else {
                            return null;
                          }
                        },
                        controller: controller.emailC,
                        decoration: InputDecoration(
                          prefixIcon: SizedBox(
                            width: 20,
                            height: 10,
                            child: Appassets.icon_mail,
                          ),
                          hintText: "Email",
                          hintStyle: AppTextStyles.kPrimaryS2W4,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: AppColors.S_text,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: AppColors.S_text,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GetBuilder<SignInController>(
                      builder: (controller) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: 56,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (_) {
                              if (_!.length < 3) {
                                return "Your password is weak, please enter strong password.";
                              }
                              return null;
                            },
                            obscureText: controller.isObsecure,
                            controller: controller.passwordC,
                            decoration: InputDecoration(
                              prefixIcon: SizedBox(
                                  width: 20,
                                  height: 10,
                                  child: Appassets.icon_lock),
                              suffixIcon: Visibility_icon(
                                press: () {
                                  controller.isObsecure =
                                      !controller.isObsecure;
                                },
                              ),
                              hintText: "Password",
                              hintStyle: AppTextStyles.kPrimaryS2W4,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: AppColors.S_text,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: AppColors.S_text,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: GetBuilder<AuthController>(builder: (controller) {
                        return Visibility(
                          visible: controller.state == ViewState.Busy ||
                              controller.errorMessage != null,
                          child: controller.errorMessage != null
                              ? Text(
                                  controller.errorMessage ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                        );
                        // return controller.errorMessage != null
                        //     ? Text(
                        //         controller.errorMessage ?? "",
                        //         textAlign: TextAlign.center,
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             color: Theme.of(context).errorColor),
                        //       )
                        //     : controller.state == ViewState.Busy
                        //         ? const Center(
                        //             child: CircularProgressIndicator.adaptive(),
                        //           )
                        //         : const SizedBox.shrink();
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Reuseable_button(

                        "Login",
                        AppColors.lightRed,
                        SvgPicture.asset(""),
                        () {
                          controller.validate();
                          // Get.to(Choose_Your_Plans());
                        },
                        isLoading: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AlreadyHaveAnAccountCheck(
                      onPress: () {
                        try {
                          Get.toNamed(
                            Routes.SIGNUP,
                          );
                        } catch (e) {
                          Logger().e(e.toString());
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
