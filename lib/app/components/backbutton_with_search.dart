import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/search_views/controllers/paid_contact_searchController.dart';

import '../../config/assets/svg_assets.dart';
import '../modules/search_views/controllers/emergency_contact_searchController.dart';
import '../modules/search_views/emergency_contact_searchview.dart';
import '../modules/search_views/paid_contact_searchview.dart';
import 'back_button.dart';

class Backbutton_with_search extends StatelessWidget {
  final bool isFromPaidContact;

  const Backbutton_with_search({Key? key, required this.isFromPaidContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding:EdgeInsets.only(top:isFromPaidContact?50:0,right: 7),
          child: InkWell(
              onTap: () {
                if (isFromPaidContact) {
                  Get.to(() => const PaidContactSearchView(), binding: PaidContactSearchBindings());
                }else{
                  Get.to(() => const EmergencyContactSearchView(), binding: EmergencyContactSearchBindings());
                }
              },
              child: Appassets.search,),
        ),
      ],
    );
  }
}