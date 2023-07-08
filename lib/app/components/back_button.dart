import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/theme/apptextstyles.dart';
import '../../config/theme/custom_app_colors.dart';

class Back_button extends StatelessWidget {
  const Back_button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.back();
        print('working');
      },
      child: Column(

        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios_new_outlined,color: AppColors.Kblue_type,),
                Text("Back",style: AppTextStyles.kPrimaryS4W1,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}