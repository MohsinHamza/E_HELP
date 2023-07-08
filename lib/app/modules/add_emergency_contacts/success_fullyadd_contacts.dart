import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:logger/logger.dart';

import '../../../config/assets/svg_assets.dart';
import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../../components/back_button.dart';
import '../../components/reuseable_button.dart';

class Add_contacts_successfully extends StatelessWidget {
  final ContactModel model;

  const Add_contacts_successfully({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Back_button(),
          const Spacer(),
          Appassets.large_done_icon,
          const SizedBox(height: 34),
          Text("You have successfully added ${model.name} as emergency contact",
              textAlign: TextAlign.center, style: AppTextStyles.kPrimaryS6W1),
          const SizedBox(height: 39),
          CircleAvatar(radius: 42, backgroundImage: CachedNetworkImageProvider(model.picture ?? "")),
          const Spacer(
            flex: 2,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Reuseable_button("See Contacts", AppColors.Kblue_type, SvgPicture.asset(""), () {
                try {
                  Get.back();
                } catch (e) {
                  Logger().e(e);
                }

                // Get.to(const PaidContacts());
              })),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}