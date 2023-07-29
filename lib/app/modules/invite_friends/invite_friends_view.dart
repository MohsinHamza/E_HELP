import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/theme/custom_app_colors.dart';
import 'controllers/invite_controller.dart';

class InviteScreen extends GetView<InviteController> {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Kblue_type,
        title: const Text('InviteScreen'),
        centerTitle: true,
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator.adaptive())
            : controller.contacts.isEmpty
                ? const Center(child: Text("No Contacts Found"))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 30),
                    shrinkWrap: true,
                    itemCount: controller.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = controller.contacts[index];
                      return ListTile(
                        title: Text(contact.displayName),
                        subtitle: Text(contact.phones.isNotEmpty
                            ? contact.phones[0].number
                            : "Unable to fetch phone number"),
                        leading: const CircleAvatar(
                            backgroundColor: AppColors.Kblue_type,
                            backgroundImage:
                                AssetImage("assets/images/defaultphoto.png")),
                        trailing: InkWell(
                          onTap: () =>
                              controller.onInvitePress(contact: contact),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.Kblue_type,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 6),
                              child: Text(
                                'Invite',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                      ;
                    },
                  );
      }),
    );
  }
}
