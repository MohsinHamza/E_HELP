import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/modules/nav_contacts/controller/emergency_contacts_controller.dart';
import 'package:getx_skeleton/app/modules/nav_users/controllers/users_controllers.dart';
import 'package:getx_skeleton/utils/functions.dart';

import '../../../../config/theme/apptextstyles.dart';
import '../../../../config/theme/custom_app_colors.dart';
import '../../../components/circular_image_widget.dart';
import '../../../routes/app_pages.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contactModel;
  final bool isEmergencyList;

  const ContactTile({Key? key, required this.contactModel, this.isEmergencyList = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isEmergencyList
          ? CircularImageWidget(
              height: 130,
              width: 60,
              imageUrl: contactModel.picture,
            )
          : null,
      /* CircleAvatar(

          radius: 36,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          //backgroundImage:CachedNetworkImageProvider(contactModel.picture??""),
          child:ClipOval(
            child:  CacheNetworkWidget(
              imageUrl: contactModel.picture,
            ),
          )),*/
      title: Text(
        contactModel.name ?? '',
        style: AppTextStyles.kPrimaryS6W5,
      ),
      subtitle: Text(
        contactModel.phoneNumber ?? '',
        style: AppTextStyles.kPrimaryS7W1,
      ),
      //delete...
      trailing: isEmergencyList
          ? Container(
              width: 89,
              height: 34,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.Kblue_type),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      tooltip: "Edit Contact",
                      splashRadius: 25,
                      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                      padding: EdgeInsets.zero,
                      onPressed: () => Get.toNamed(Routes.getRouteAddEmergencyContact(model: contactModel)),
                      icon: Image.asset("assets/icons/edit_Profile.png")),
                  IconButton(
                      tooltip: "Delete Contact",
                      splashRadius: 25,
                      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                      padding: EdgeInsets.zero,
                      onPressed: () => {
                            Functions.showConfirmDialog(
                                confirm: () async {
                                  await Get.find<EmergencyContactsController>().deleteEmergencyContact(contactModel);
                                },
                                content: "Are you sure want to delete ${contactModel.name} from Emergency Contacts?",
                                title: "Delete Contact"),
                          },
                      icon: Image.asset("assets/icons/delete.png")),
                ],
              ))
          : Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.Kblue_type),
              child: IconButton(
                  tooltip: "Delete Contact",
                  splashRadius: 25,
                  visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                  padding: EdgeInsets.zero,
                  onPressed: () => {
                        Functions.showConfirmDialog(
                            confirm: () async {
                              await Get.find<UsersController>().deletePaidContact(contactModel);
                            },
                            content: "Are you sure want to delete ${contactModel.name} from your Paid contact list?",
                            title: "Delete Contact")
                      },
                  icon: Image.asset("assets/icons/delete.png")),
            ),
    );
  }
}