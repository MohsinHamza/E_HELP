import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/nav_users/controllers/users_controllers.dart';

import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../../base_controller.dart';
import '../../components/backbutton_with_search.dart';
import '../../components/invite_friends_get_off_widget.dart';
import '../../routes/app_pages.dart';
import '../nav_contacts/components/contact_tile.dart';

class PaidContacts extends GetView<UsersController> {
  const PaidContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Backbutton_with_search(
            isFromPaidContact: true,
          ),
          const SizedBox(height: 31),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                     Text("Your Paid Contacts", style: AppTextStyles.kPrimaryS6W3),
                    InviteFriendsGetOffTextWidget(),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.PAY_FOR_FAMILY_FRIEND);
                    },
                    child: const Icon(
                      Icons.add_circle,
                      size: 32,
                      color: AppColors.Kblue_type,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 31),
          Expanded(
            child: EasyRefresh(
              onRefresh: controller.fetchPaidContacts,
              child: GetBuilder<UsersController>(
                builder: (controller) {
                  if (controller.state == ViewState.Busy) {
                    return const Center(child: CircularProgressIndicator.adaptive());
                  }
                  if (controller.paidContactList?.isEmpty ?? true) {
                    return const Center(child: Text("Add your friends/family By Clicking + Button"));
                  }
                  return ListView.separated(
                      padding: EdgeInsets.zero,
                      // shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) =>
                          ContactTile(contactModel: controller.paidContactList![index], isEmergencyList: false),
                      separatorBuilder: (_, __) => const Padding(padding: EdgeInsets.symmetric(horizontal: 13.0), child: Divider()),
                      itemCount: controller.paidContactList!.length);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}