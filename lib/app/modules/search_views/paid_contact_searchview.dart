import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/my_widgets_animator.dart';
import 'package:getx_skeleton/app/modules/search_views/controllers/paid_contact_searchController.dart';

import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../nav_contacts/components/contact_tile.dart';

class PaidContactSearchView extends GetView<PaidContactSearchController> {
  const PaidContactSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Contacts", style: AppTextStyles.kPrimaryS7W2.copyWith(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller.searchController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              onChanged: controller.onSearchTextChanged,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search Paid Contact",
                  hintStyle: AppTextStyles.kPrimaryS2W4,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: AppColors.S_text), borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: AppColors.S_text), borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            Obx(() => MyWidgetsAnimator(
                  apiCallStatus: controller.apiCallStatus.value,
                  holdingWidget: () => const Center(child: Text("Search your contacts")),
                  emptyWidget: () => const Center(child: Text("No contacts found")),
                  loadingWidget: () => const Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: () => const Center(child: Text("No contacts found")),
                  successWidget: () => Obx(
                    () => ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) =>
                            ContactTile(contactModel: controller.searchList.value[index], isEmergencyList: false),
                        separatorBuilder: (_, __) => const Padding(padding: EdgeInsets.symmetric(horizontal: 13.0), child: Divider()),
                        itemCount: controller.searchList.value.length),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}