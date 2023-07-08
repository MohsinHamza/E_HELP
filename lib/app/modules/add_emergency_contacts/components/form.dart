import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/base_controller.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/modules/add_emergency_contacts/controller/add_emergency_contacts_controller.dart';
import 'package:getx_skeleton/app/services/form_validation_services.dart';

import '../../../../config/theme/apptextstyles.dart';
import '../../../../config/theme/custom_app_colors.dart';
import '../../../components/reuseable_button.dart';
import '../success_fullyadd_contacts.dart';

class AddEmergencyContactForm extends StatefulWidget {
  final ContactModel? model;

  const AddEmergencyContactForm({Key? key, required this.model})
      : super(key: key);

  @override
  State<AddEmergencyContactForm> createState() =>
      _AddEmergencyContactFormState();
}

class _AddEmergencyContactFormState extends State<AddEmergencyContactForm> {
  String selectedValue = "Parent";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "Parent",
        child: Text(
          "Parent",
          style: AppTextStyles.kPrimaryS5W4,
        ),
      ),
      const DropdownMenuItem(
        value: "Sibling",
        child: Text(
          "Sibling",
          style: AppTextStyles.kPrimaryS5W4,
        ),
      ),
      const DropdownMenuItem(
        value: "Friend",
        child: Text(
          "Friend",
          style: AppTextStyles.kPrimaryS5W4,
        ),
      ),
      const DropdownMenuItem(
        value: "Relative",
        child: Text(
          "Relative",
          style: AppTextStyles.kPrimaryS5W4,
        ),
      ),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: GetBuilder<AddEmergencyContactsController>(
        builder: (controller) {
          return Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 39,
                ),
                const Text(
                  "Name",
                  style: AppTextStyles.kPrimaryS5W4,
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 52,
                  child: TextFormField(
                    controller: controller.nameC,
                    validator: FormValidationService.checkEmpty,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintStyle: AppTextStyles.kPrimaryS2W4,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                const Text(
                  "Phone Number",
                  style: AppTextStyles.kPrimaryS5W4,
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 52,
                  child: TextFormField(
                    controller: controller.phoneNumberC,
                    validator: FormValidationService.checkEmpty,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintStyle: AppTextStyles.kPrimaryS2W4,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: AppColors.S_text),
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                const Text(
                  "Relation",
                  style: AppTextStyles.kPrimaryS5W4,
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      width: 1,
                      color: AppColors.S_text,
                    ),
                  ),
                  child: DropdownButton(
                    value: selectedValue,
                    items: dropdownItems,
                    isExpanded: true,
                    underline: Container(),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down_sharp,
                      size: 28,
                    ),
                    onChanged: (String? value) {
                      controller.relationC.text = value!;
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: controller.state == ViewState.Busy
                        ? const CircularProgressIndicator.adaptive()
                        : Reuseable_button(
                            widget.model == null ? "Add" : "Update",
                            AppColors.Kblue_type,
                            SvgPicture.asset(""), () async {
                            FocusScope.of(context).unfocus();
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            controller.validateField(widget.model);
                            // await controller.addOrUpdateEmergencyContact(contactModel: widget.model);
                            // // widget.model == null
                            // //     ? Get.to(Add_contacts_successfully(
                            // //         model: controller.contact!,
                            // //       ))
                            // //     : null;
                          })),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
