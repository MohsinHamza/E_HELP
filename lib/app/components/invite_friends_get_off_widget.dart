import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';

class InviteFriendsGetOffTextWidget extends StatelessWidget {
  const InviteFriendsGetOffTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.INVITE);
        // Get.to(() => const InviteScreen(),binding: InviteBindings());
      },
      child: const Text("Invite friends & get 5\$ each", style: TextStyle(fontSize: 13, color: Colors.grey)),
    );
  }
}