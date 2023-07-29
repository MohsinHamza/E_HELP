import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/rounded_border_widget.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';
import 'package:getx_skeleton/utils/DateFormate_utils.dart';
import 'package:getx_skeleton/utils/functions.dart';
import 'package:logger/logger.dart';
import '../../../config/assets/svg_assets.dart';
import '../../../config/theme/apptextstyles.dart';
import '../../components/CacheNetworkWidget.dart';
import '../../components/invite_friends_get_off_widget.dart';
import '../../routes/app_pages.dart';
import '../../services/in_app_purchases_service.dart';
import '../feeback_screen/feedback_Screen.dart';
import 'components/listtile_profile.dart';
import 'controller/profile_controller.dart';

class Profile_Page extends GetView<ProfileController> {
  const Profile_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyAppUser myAppUser = Get.find<MyAppUser>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black,),
        title: GetBuilder<ProfileController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () => controller.toggleEditMode(),
                    child: Text(
                      controller.isEditMode ? "Cancel" : "Edit",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                if (controller.isEditMode)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 30, bottom: 10),
                    child: InkWell(
                      onTap: () => controller.saveButton(),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height - 60,
                child: ListView(
                  children: [
                    InkWell(
                      onTap: () => controller.isEditMode
                          ? Functions.showImagePickerBS(
                        context,
                        model: controller,
                      )
                          : null,
                      child: RoundedBorderWidget(
                        borderRadius: 20,
                        child: controller.file != null
                            ? Image.file(
                          File(
                            controller.file!.path,
                          ),
                          height: controller.isEditMode ? 120 : 80,
                          width: controller.isEditMode ? 120 : 80,
                        )
                            : FirebaseAuth.instance.currentUser!.photoURL ==
                            null
                            ? Container(
                          height:
                          controller.isEditMode ? 120 : 80,
                          width: controller.isEditMode ? 120 : 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/svg_icons/profile.png",
                            height:
                            controller.isEditMode ? 120 : 80,
                            width:
                            controller.isEditMode ? 120 : 80,
                          ),
                        )
                            : CacheNetworkWidget(
                          imageUrl: FirebaseAuth
                              .instance.currentUser!.photoURL!,
                          height:
                          controller.isEditMode ? 120 : 80,
                          width: controller.isEditMode ? 120 : 80,
                          loadingWidget: myAppUser.profileurl !=
                              null
                              ? Stack(
                            children: [
                              Image.asset(
                                "assets/images/defaultphoto.png",
                                height:
                                controller.isEditMode
                                    ? 120
                                    : 80,
                                width: controller.isEditMode
                                    ? 120
                                    : 80,
                              ),
                              const Positioned(
                                top: 30,
                                left: 35,
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child:
                                    CircularProgressIndicator()),
                              ),
                            ],
                          )
                              : const SizedBox.shrink(),
                          errorWidget: Container(
                            color: Colors.grey.shade200,
                            height: 120,
                            width: 120,
                            child: const Icon(
                              Icons.person,
                              size: 80,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !controller.isEditMode,
                      child: Column(
                        children: [
                          Text(
                            myAppUser.name ?? "",
                            style: AppTextStyles.kPrimaryS9W1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            "Online",
                            style: AppTextStyles.kPrimaryS9W2,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: controller.isEditMode
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: !controller.isEditMode,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Invites :",
                                            style: AppTextStyles.kPrimaryS9W1,
                                          ),
                                          StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .collection("signedOnMyInvitation")
                                                .where('type', isEqualTo: 'redeemedBy')
                                                .snapshots(),
                                            builder: (_,
                                                AsyncSnapshot<QuerySnapshot> snapshots) {
                                              if (snapshots.hasData) {
                                                int number = snapshots.data!.docs.length;
                                                return Center(
                                                  child: Text(
                                                    number < 9 ? ' 0$number' : ' $number',
                                                    style: AppTextStyles.kPrimaryS8W3.copyWith(fontSize: 22),
                                                  ),
                                                );
                                              } else {
                                                return  Center(
                                                  child: Text(
                                                    " 00",
                                                    style: AppTextStyles.kPrimaryS8W3.copyWith(fontSize: 22),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: !controller.isEditMode,
                                  child: const Text("Invite friends & get 5\$ each", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !controller.isEditMode,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  Get.toNamed(Routes.INVITE);
                                },
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      "Invite",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _editProfile(controller.isEditMode, context),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xffE3E3E3))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile_Profile(
                            "Username",
                            myAppUser.name ?? "<Not Setted Yet>",
                            isVisible: !controller.isEditMode,
                          ),
                          ListTile_Profile(
                            "Email",
                            myAppUser.email ?? "<Not Setted Yet>",
                            isVisible: !controller.isEditMode,
                          ),
                          // ListTile_Profile(
                          //   "First/Last Name",
                          //   myAppUser.name ?? "<Not Setted Yet>",
                          //   isVisible: !controller.isEditMode,
                          // ),
                          ListTile_Profile(
                            "Phone Number",
                            myAppUser.phonenumber ?? "<Not Setted Yet>",
                            isVisible: !controller.isEditMode,
                          ),
                          ListTile_Profile(
                            "Date of Birth",
                            controller.myAppUser.dob != null
                                ? CustomeDateFormate.DOB(controller.myAppUser.dob)
                                : "25-05-2000",
                            isVisible: !controller.isEditMode,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Visibility(
                            visible: !controller.isEditMode,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 8),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  try {
                                    Get.find<MyAppUser>().signOut();
                                    // PurchasesApi.logout();
                                  } catch (e) {
                                    Logger().e(e.toString());
                                  }
                                },
                                child: Center(
                                  child: const Text(
                                    "Log out",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _editProfile(bool isEditMode, context) {
    return Visibility(
      visible: controller.isEditMode,
      child: Column(
        children: [
          _editField(isEditMode, controller.phoneNumber, TextInputType.number,
              'update your phone number'),
          const SizedBox(
            height: 12,
          ),
          _editField(isEditMode, controller.name, TextInputType.text,
              'update your name'),
          const SizedBox(
            height: 12,
          ),
          _editDateOfBirth(isEditMode, context),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  _editField(bool isEditMode, TextEditingController controller,
      TextInputType keyboardType, String hintText) {
    return Visibility(
      visible: isEditMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: const Icon(
              Icons.edit,
            ),
          ),
        ),
      ),
    );
  }

  _editDateOfBirth(bool isEditMode, BuildContext context) {
    return Visibility(
      visible: isEditMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.lightRed,
                width: 1.2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.dummyDate,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, bottom: 10),
                child: InkWell(
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1912, 1, 1),
                      lastDate: DateTime(2025, 1, 1),
                    );
                    var dateList = date.toString().split(' ')[0].split('-');
                    var dateParts = '';
                    dateParts = dateList[2] + dateList[1] + dateList[0];
                    controller.dummyDate =
                        dateList[2] + '-' + dateList[1] + '-' + dateList[0];
                    print(int.parse(dateParts));
                    controller.myAppUser.dob = date!.millisecondsSinceEpoch;
                    controller.update();
                  },
                  child: const Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
