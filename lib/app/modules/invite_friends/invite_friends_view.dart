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
                    shrinkWrap: true,
                    itemCount: controller.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = controller.contacts[index];
                      return ListTile(
                        title: Text(contact.displayName),
                        subtitle: Text(contact.phones.isNotEmpty ? contact.phones[0].number : "Unable to fetch phone number"),
                        leading: const CircleAvatar(backgroundColor: AppColors.Kblue_type, backgroundImage: AssetImage("assets/images/defaultphoto.png")),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(elevation: 0.0, primary: AppColors.Kblue_type, side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                          child: const Text('Invite'),
                          onPressed: () => controller.onInvitePress(contact: contact),
                        ),
                      );
                      ;
                    },
                  );
      }),
    );
  }
}
