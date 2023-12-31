import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/theme/custom_app_colors.dart';
import '../routes/app_pages.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.EMERGENCY, id: 1);
      },
      child: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(bottom: 20.0),
        //padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
           shape: BoxShape.circle,
            color: AppColors.lightRed,
            boxShadow: [
              BoxShadow(
                color: AppColors.lightRed.withOpacity(0.3),
                offset: const Offset(2, 3),
                spreadRadius: 1,
                blurRadius: 3,
              )
            ]),
        child: Container(
          height: 60,
          width: 40,
          padding: const EdgeInsets.all(8),
          child: const Image(
            image: AssetImage('assets/svg_icons/alert-icon.png'),
          ),
        ),
        // child: Row(
        //   children: [
        //     Container(
        //       height: 60,
        //       width: 40,
        //       padding: const EdgeInsets.all(8),
        //       child: const Image(
        //         image: AssetImage('assets/svg_icons/alert-icon.png'),
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 5,
        //     ),
        //     const Text(
        //       "Send Alert",
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 17,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
