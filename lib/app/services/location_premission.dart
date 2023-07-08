import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/controllers/app_config_controller.dart';
import 'package:getx_skeleton/app/modules/nav_emergency/transaction_alert.dart';

import '../../config/assets/svg_assets.dart';
import '../../config/theme/apptextstyles.dart';
import '../../config/theme/custom_app_colors.dart';
import '../../utils/functions.dart';

class LocationScreen extends GetView<AppConfigController> {
  final bool? isFromExpired;
  final bool isMonthlySelected;

  const LocationScreen({Key? key, this.isFromExpired, this.isMonthlySelected = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<AppConfigController>(builder: (controller) {
            return //controller.isLocationEnabled
                // ?  calendarTest()
               // ?
                const SendAlertScreen();
            // : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //     const Spacer(),
            //     Appassets.location_icon,
            //     const SizedBox(
            //       height: 33,
            //     ),
            //     const Text(
            //       "Enable Permission location",
            //       style: TextStyle(
            //         fontWeight: FontWeight.w400,
            //         fontSize: 24,
            //         color: Colors.redAccent,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //     const SizedBox(
            //       height: 13,
            //     ),
            //     const Text(
            //       "This app needs access to location when open to use it in case of a medical emergency to relay to local 911 authorities and translate your location. Medical Emergency Network Agents correspond with local 911 authorities we use your location to give to 911 so that way they’re able to have your current location in the case of a medical emergency",
            //       textAlign: TextAlign.center,
            //       style: AppTextStyles.kPrimaryS7W3,
            //     ),
            //     const SizedBox(
            //       height: 37,
            //     ),
            //     Container(
            //       width: double.infinity,
            //       margin: const EdgeInsets.symmetric(horizontal: 15),
            //       child: ElevatedButton(
            //         style: ButtonStyle(
            //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(5.0),
            //           )),
            //           backgroundColor: MaterialStateProperty.all<Color>(AppColors.Kblue_type),
            //         ),
            //         onPressed: () async {
            //           bool isGranted = await Functions.requestForLocationPermission();
            //           if (isGranted) {
            //             controller.setLocationPermission = true;
            //             controller.update();
            //           }
            //
            //           // print("pressed ENABLE");
            //           //  Get.to(Payment_page(1));
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: const [
            //               Text("Enable", style: AppTextStyles.kPrimaryS5W3),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     const Spacer(),
            //     Appassets.place_holder,
            //     const SizedBox(
            //       height: 40,
            //     )
            //   ]);
          }),
          if (isFromExpired ?? false)
            const Positioned(
                top: 10,
                left: 0,
                child: SafeArea(
                  child: BackButton(),
                ))
        ],
      ),
    );
  }
}
