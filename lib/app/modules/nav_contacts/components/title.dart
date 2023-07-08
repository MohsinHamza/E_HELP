import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';

import '../../../../config/theme/apptextstyles.dart';
import '../../../../config/theme/custom_app_colors.dart';
import '../../../components/invite_friends_get_off_widget.dart';
import '../../../data/models/contact_model.dart';

class Title_emergency_contacts extends StatelessWidget {
  const Title_emergency_contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 13),
      child: ListTile(
          leading: Image.asset('assets/icons/add-contact.png',fit: BoxFit.cover,height: 50,width: 50,),
          title:Text(
            "EMERGENCY CONTACTS",
            style: AppTextStyles.kPrimaryS8W1.copyWith(
              fontSize: 17,
            ),
          ),
          subtitle:const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: InviteFriendsGetOffTextWidget(),
          ),
        trailing:
        GestureDetector(
          onTap: () {
            Get.toNamed(
              Routes.getRouteAddEmergencyContact(),
            );
            // Get.to(Add_Emergency_contact());
          },
          child: const Icon(
            Icons.add_circle,
            size: 32,
            color: AppColors.Kblue_type,
          ),
        ),

      ),
    );
  }
}
