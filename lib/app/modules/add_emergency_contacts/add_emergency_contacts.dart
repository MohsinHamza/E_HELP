import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/CacheNetworkWidget.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/modules/add_emergency_contacts/controller/add_emergency_contacts_controller.dart';
import 'package:getx_skeleton/utils/functions.dart';

import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import 'components/form.dart';

class AddEmergencyContact extends GetView<AddEmergencyContactsController> {
  final ContactModel? contact;

  const AddEmergencyContact({Key? key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contact != null) controller.fillFields(contactModel: contact);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                      Text(
                        'Add Emergency Contact',
                        style: AppTextStyles.kPrimaryS5W3
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.3 - 55,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_ImageWidget()],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        left: 120,
                        bottom: 0,
                        child: InkWell(
                          onTap: () => Functions.showImagePickerBS(context,
                              model: controller),
                          child: const CircleAvatar(
                            backgroundColor: AppColors.Kblue_type,
                            radius: 15,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AddEmergencyContactForm(
                  model: contact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ImageWidget() {
    return GetBuilder<AddEmergencyContactsController>(
      builder: (controller) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: controller.file != null
            ? Image.file(File(controller.file!.path),
                height: 120, width: 120, fit: BoxFit.cover)
            : CacheNetworkWidget(
                imageUrl: contact?.picture,
                height: 120,
                width: 120,
                loadingWidget: contact?.picture != null
                    ? const CircularProgressIndicator.adaptive()
                    : const SizedBox.shrink(),
                errorWidget: Container(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    'assets/svg_icons/profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }
}
