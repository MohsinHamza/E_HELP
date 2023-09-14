import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/base_controller.dart';
import 'package:getx_skeleton/app/modules/nav_contacts/controller/emergency_contacts_controller.dart';

import '../../components/backbutton_with_search.dart';
import 'components/contact_tile.dart';
import 'components/title.dart';

class EmergencyContacts extends GetView<EmergencyContactsController> {
  const EmergencyContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.redAccent,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Backbutton_with_search(isFromPaidContact: false),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 31),
          const Title_emergency_contacts(),
          const SizedBox(height: 19),
          Expanded(
            child: EasyRefresh(
              simultaneously: true,
              onRefresh: controller.fetchEmergencyContacts,
              child: GetBuilder<EmergencyContactsController>(
                builder: (controller) {
                  if (controller.state == ViewState.Busy) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (controller.emergencyContactList == null ||
                      controller.emergencyContactList!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                            "You Can Add New Emergency Contact By Clicking + Button",
                            textAlign: TextAlign.center),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, index) => ContactTile(
                      contactModel: controller.emergencyContactList![index],
                      isEmergencyList: true,
                    ),
                    separatorBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 13.0,
                        ),
                        child: Divider()),
                    itemCount: controller.emergencyContactList!.length,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
