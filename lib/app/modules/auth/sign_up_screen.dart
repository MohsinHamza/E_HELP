import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getx_skeleton/app/modules/auth/controller/signUp_controller.dart';
import 'package:getx_skeleton/app/modules/auth/pick_photos_screen.dart';
import 'package:getx_skeleton/utils/DateFormate_utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/assets/svg_assets.dart';
import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../../base_controller.dart';
import '../../components/reuseable_button.dart';
import '../../data/local/dynamic_link_payload_model.dart';
import '../../data/local/invited_contact.dart';
import 'components/already_have_an_account_check.dart';

import 'components/visibility_icon.dart';
import 'controller/auth_controller.dart';

class SignupScreen extends GetView<SignUpController> {
  final DynamicLinkPayloadModel? dynamicLinkPayloadModel;
  final InvitedContactModel? invitedContactModel;

  const SignupScreen(
      {Key? key,
      required this.dynamicLinkPayloadModel,
      this.invitedContactModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDynamicLink = dynamicLinkPayloadModel != null;
    if (dynamicLinkPayloadModel != null) {
      controller.guadrianId.text = dynamicLinkPayloadModel?.guardianUid ?? "";
      controller.phoneC.text = dynamicLinkPayloadModel?.phoneNumber ?? "";
    }
    if (invitedContactModel != null) {
      controller.referralCodeC.text = invitedContactModel?.invitedBy ?? "";
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: controller.formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GetBuilder<SignUpController>(builder: (c) {
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.redAccent,
                            child: controller.profile == null
                                ? Image.asset(
                                    'assets/svg_icons/profile.png',
                                    fit: BoxFit.cover,
                                    height: 340,
                                    width: 340,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.file(
                                        controller.profile!,
                                        fit: BoxFit.cover,
                                        height: 340,
                                        width: 340,
                                      ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 2,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => const PickPhotoScreen());
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(2, 3),
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                      )
                                    ]),
                                padding: const EdgeInsets.all(3),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 8),
                    Text(
                      'Registration',
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    isDynamicLink
                        ? Text(
                            dynamicLinkPayloadModel?.invitedByString() ?? "",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Please enter your account here',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 56,
                      child: TextFormField(
                        controller: controller.usernameC,
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 15, top: 12),
                              child: FaIcon(FontAwesomeIcons.user,
                                  size: 22, color: AppColors.Proyel_blue)),
                          hintText: "User Name",
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 56,
                      child: TextFormField(
                        controller: controller.firstlastNameC,
                        decoration: InputDecoration(
                            prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 15, top: 12),
                                child: FaIcon(FontAwesomeIcons.user,
                                    size: 22, color: AppColors.Proyel_blue)),
                            hintText: "First/Last Name",
                            hintStyle: AppTextStyles.kPrimaryS2W4,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: AppColors.S_text),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: AppColors.S_text),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 67,
                      child: TextFormField(
                        controller: controller.emailC,
                        validator: (_) {
                          if (!GetUtils.isEmail(_!)) {
                            return "Enter valid email";
                          }
                        },
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 56,
                      child: TextFormField(
                        enabled: !isDynamicLink,
                        controller: controller.phoneC,
                        validator: (_) {
                          if (!GetUtils.isPhoneNumber(_!)) {
                            return "Enter valid phone number";
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const SizedBox(
                            width: 20,
                            height: 10,
                            child: Icon(
                              Icons.phone,
                              size: 28,
                              color: AppColors.Proyel_blue,
                            ),
                          ),
                          hintText: "Phone number",
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 56,
                      child: InkWell(
                        onTap: () async {
                          DatePicker.showDatePicker(
                            context,
                            dateFormat: 'dd MMMM yyyy',
                            initialDateTime: DateTime.now(),
                            // minDateTime: DateTime.now().subtract(const Duration(days: 365 * 80)),
                            maxDateTime: DateTime.now(),
                            onMonthChangeStartWithFirstDate: true,
                            onConfirm: (dateTime, List<int> index) {
                              controller.dobC.text = CustomeDateFormate.DOB(
                                  dateTime.millisecondsSinceEpoch);
                            },
                          );
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextFormField(
                            validator: (_) {
                              if (_?.isEmpty ?? true) {
                                return "Enter date of birth";
                              }
                            },
                            readOnly: true,
                            controller: controller.dobC,
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  top: 12,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.calendar,
                                  size: 20,
                                  color: AppColors.Proyel_blue,
                                ),
                              ),
                              hintText: "Date of Birth",
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
                      ),
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<SignUpController>(builder: (controller) {
                      return Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 56,
                            child: Stack(
                              children: [
                                TextFormField(
                                  readOnly: true,
                                  controller: controller.countryC,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      FontAwesomeIcons.globe,
                                      color: AppColors.Proyel_blue,
                                      size: 20,
                                    ),
                                    hintText: "Your Country",
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
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    showCountryPicker(
                                      context: context,
                                      onSelect: (country) {
                                        controller.countryC.text = country.name;
                                        controller.selectedCountryCode =
                                            country.countryCode;
                                      },
                                      countryListTheme:
                                          const CountryListThemeData(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        inputDecoration: InputDecoration(
                                          labelText: 'Search',
                                          hintText: 'Start typing to search',
                                          hintStyle: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 15,
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 15,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.redAccent,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                        searchTextStyle: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  },
                                  // child: CustomDropDownPopup(
                                  //   iconData: Icons.arrow_drop_down,
                                  //   dropDownList: controller.countries,
                                  //   onSelected: (CountryModel model) {
                                  //     controller.countryC.text = model.name;
                                  //     controller.selectedCountryCode = model.code;
                                  //   },
                                  // ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 56,
                            child: TextFormField(
                              obscureText: controller.isObsecure,
                              controller: controller.passwordC,
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                  width: 20,
                                  height: 10,
                                  child: Appassets.icon_lock,
                                ),
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
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 56,
                            child: TextFormField(
                              obscureText: controller.isObsecure,
                              controller: controller.confirmPasswordC,
                              validator: (_) {
                                if (_.toString() != controller.passwordC.text) {
                                  return "Password doesnt matched!";
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                  width: 20,
                                  height: 10,
                                  child: Appassets.icon_lock,
                                ),
                                suffixIcon: Visibility_icon(
                                  press: () {
                                    controller.isObsecure =
                                        !controller.isObsecure;
                                  },
                                ),
                                hintText: "Confirm Password",
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
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: GetBuilder<AuthController>(
                        builder: (controller) {
                          return Visibility(
                            visible: controller.state == ViewState.Busy ||
                                controller.errorMessage != null,
                            child: controller.errorMessage != null
                                ? Text(
                                    controller.errorMessage ?? "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).errorColor,
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                          );
                        },
                      ),
                    ),
                    if (invitedContactModel != null)
                      const Text(
                        "You will get 14-days trial, on your first subscription",
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Reuseable_button(
                        "Sign Up",
                        AppColors.lightRed,
                        SvgPicture.asset(""),
                        () {
                          controller.validate(
                            payload: dynamicLinkPayloadModel,
                            invitedContactModel: invitedContactModel,
                          );
                          // Get.to(Choose_Your_Plans());
                        },
                        isLoading: false,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      onPress: () {
                        Get.back();
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
