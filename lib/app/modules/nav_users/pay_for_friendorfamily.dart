import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/nav_contacts/controller/pay_for_friend_family_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../../components/back_button.dart';
import '../../components/reuseable_button.dart';

class PayForFriendFamilyScreen extends StatefulWidget {
  const PayForFriendFamilyScreen({Key? key}) : super(key: key);

  @override
  State<PayForFriendFamilyScreen> createState() => _PayForFriendFamilyScreenState();
}

class _PayForFriendFamilyScreenState extends State<PayForFriendFamilyScreen> {
  final controller = PayForFriendFamilyController.find;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PayForFriendFamilyController>(builder: (controller) {
        return SafeArea(
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                const Back_button(),
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 24),
                  child: Text("Pay for a friend or family", style: AppTextStyles.kPrimaryS7W2),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 27.0),
                  child: Text("Name", style: AppTextStyles.kPrimaryS5W4),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 23, right: 37, top: 2, bottom: 19),
                  height: 52,
                  child: TextFormField(
                    onTap: () {
                      controller.nameFocus.requestFocus();
                    },
                    focusNode: controller.nameFocus,
                    controller: controller.nameC,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintStyle: AppTextStyles.kPrimaryS2W4,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 27.0),
                  child: Text("Phone Number", style: AppTextStyles.kPrimaryS5W4),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 23, right: 37, top: 2, bottom: 19),
                  height: 75,
                  child: IntlPhoneField(
                    onTap: () {
                      controller.phoneNumberFocus.requestFocus();
                    },
                    focusNode: controller.phoneNumberFocus,
                    decoration: InputDecoration(
                        hintStyle: AppTextStyles.kPrimaryS2W4,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        )),
                    initialCountryCode: 'US',
                    onChanged: (phone) {
                      controller.phoneNumberC.text = phone.completeNumber;
                    },
                  ),
                ),
              if(controller.priceList.isNotEmpty)  const Padding(
                  padding: EdgeInsets.only(left: 27.0),
                  child: Text("Select Subscription Plan", style: AppTextStyles.kPrimaryS5W4),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 23, right: 37, top: 0, bottom: 19),
                  height: 52,
                  child: Row(
                      children: controller.priceList
                          .map(
                            (e) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Radio(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: e.priceName.toString(),
                                    groupValue: controller.subscriptionC.text,
                                    onChanged: (value) => controller.onClickRadioButton(value)),
                                Text(e.priceName.toString().toUpperCase() + "LY")
                              ],
                            ),
                          )
                          .toList()),
                ),
                const SizedBox(height: 24),
                GetBuilder<PayForFriendFamilyController>(builder: (controller) {
                  if (controller.priceList.isEmpty) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text("Unfortunately there are no payment plan available, We are working on it. Please try again later",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.S_text,
                          ),
                          textAlign: TextAlign.center),
                    ));
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 23, right: 37, top: 2, bottom: 19),
                    child: Reuseable_button(
                        controller.priceModel == null
                            ? "Select Subscription"
                            : "Buy Subscription       \$${(controller.priceModel!.price / 100).toStringAsFixed(0)} "
                                " (Per ${controller.priceModel?.priceName})",
                        AppColors.Kblue_type,
                        SvgPicture.asset(""), () async {
                      // if( controller.priceList.isEmpty){
                      //   CustomSnackBar.showCustomErrorToast(title: "Server Problem" , message: "No Subscription Plan Available, "
                      //       "Please try "
                      //       "again later we are working on it.");
                      // }
                      if (controller.priceModel != null) {
                        controller.submit();
                      }
                    }),
                  );
                }),
                /*      const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17.0),
                      child: Reuseable_button("Monthly Work", AppColors.Kblue_type, SvgPicture.asset(""), () async {
                        ///TODO: uncomment this controller submit...
                        // SubscriptionPaymentController.create.processPayment(isMonthly: true, model: controller.model);

                        ///  await controller.submit();
                        //testSheet();
                        //initPaymentSheet();
                        // Get.to(Payment_page(2));
                      }),
                    ),*/
                // const Spacer(flex: 4)
              ],
            ),
          ),
        );
      }),
    );
  }
}