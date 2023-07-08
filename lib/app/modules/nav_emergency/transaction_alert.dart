import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/choose_plans/calendat_booking_view.dart';
import 'package:getx_skeleton/app/modules/nav_emergency/controllers/transaction_alert_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:vibration/vibration.dart';
import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../../../utils/men_alert_animation.dart';
import '../../../utils/size_config.dart';
import '../../controllers/my_app_user.dart';

class SendAlertScreen extends StatefulWidget {
  const SendAlertScreen({Key? key}) : super(key: key);

  @override
  State<SendAlertScreen> createState() => _SendAlertScreenState();
}

class _SendAlertScreenState extends State<SendAlertScreen>
    with TickerProviderStateMixin {
  CountdownController? countdownController =
      CountdownController(autoStart: false);
  TransactionAlertController controller = TransactionAlertController();

  String alertType = 'ambulance';
  Timer? _timer;

  @override
  void initState() {
    ///todo: berta enable ka kha
    // Purchases.addCustomerInfoUpdateListener((info) async {
    //   info.entitlements.active;
    //
    //   print(info.entitlements.all);
    //   if (info.entitlements.all['Solo Plan'] == null &&
    //       info.entitlements.all['Solo Plan']!.isActive == false &&
    //       info.entitlements.all['Solo Plan']!.willRenew == false) {
    //     MyAppUser myAppUser = MyAppUser.find;
    //
    //     MyAppUser.find.isSubscriptionExpired = true;
    //     MyAppUser.find.subscriptionExpiryMilliseconds = null;
    //     MyAppUser.find.update(myAppUser);
    //     await FirebaseFirestoreService.find
    //         .updateSubscriptionStatus(days: null, isExpired: true);
    //     setState(() {
    //
    //     });
    //   }
    //
    // });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final MyAppUser myAppUser = MyAppUser.find;
    BoxConstraints constraints = BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height);
    SizeConfig().init(constraints, Orientation.portrait);
    return Scaffold(
      key: _scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.face),
      //   onPressed: () async {
      //     List<Offering> offers = await PurchasesApi.fetchOffers();
      //     print('offers.lenght: ${offers[0].availablePackages.length}');
      //   },
      // ),
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.menu),
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
            ),

            Obx(() {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 13.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EmergencyItemCircle(
                            title: "ambulance",
                            onTap: (val) {
                              alertType = "ambulance";
                              controller.onEmergencyTypeTap("ambulance");
                            },
                            isSelected:
                                controller.alertType.value == "ambulance"),
                        Spacer(),
                        EmergencyItemCircle(
                            title: "firebrigade",
                            onTap: (val) {
                              alertType = "firebrigade";
                              controller.onEmergencyTypeTap("firebrigade");
                            },
                            isSelected:
                                controller.alertType.value == "firebrigade"),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EmergencyItemCircle(
                            title: "coast guard",
                            onTap: (val) {
                              alertType = "coast guard";
                              controller.onEmergencyTypeTap("coast guard");
                            },
                            isSelected:
                                controller.alertType.value == "coast guard"),
                        Spacer(),
                        EmergencyItemCircle(
                            title: "police",
                            onTap: (val) {
                              alertType = "police";
                              controller.onEmergencyTypeTap("police");
                            },
                            isSelected: controller.alertType.value == "police"),
                      ],
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            //Type of Alert
            GetBuilder<TransactionAlertController>(
              init: TransactionAlertController(),
              builder: (controller) {
                return Center(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //count down of send alert!
                          Listener(
                            onPointerDown: controller.isAlertSent.value

                                ///todo:berta enable ka
                                // || myAppUser.isSubscriptionExpired ==
                                // null ||
                                // myAppUser
                                //     .isSubscriptionExpired == true
                                ? (d) {}
                                : (details) async {
                                    controller.isAlertSent.value = false;
                                    countdownController?.start();
                                    if (await Vibration.hasVibrator() == true) {
                                      Vibration.vibrate(duration: 6000);
                                    }
                                  },
                            onPointerUp: controller.isAlertSent.value

                                ///todo:berta enable ka
                                //     || myAppUser.isSubscriptionExpired ==
                                //     null ||
                                //     myAppUser
                                //         .isSubscriptionExpired == true
                                ? (d) {}
                                : (details) {
                                    countdownController?.restart();
                                    countdownController?.pause();
                                  },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Column(
                                children: [
                                  GetBuilder<TransactionAlertController>(
                                      builder: (con) {
                                    return con.isAlertSent.value == true
                                        ? const Text(
                                            'Emergency Help Has Been Contacted! \nDon\'t Close App for 5 minutes',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.6,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Countdown(
                                            seconds: 6,
                                            controller: countdownController,
                                            build: (BuildContext context,
                                                    double time) =>
                                                Text(
                                              time == 6.0
                                                  ?

                                                  ///todo:da hm esta berta enable ka bia
                                                  // myAppUser.isSubscriptionExpired ==
                                                  //             null ||
                                                  //         myAppUser
                                                  //                 .isSubscriptionExpired ==
                                                  //             true
                                                  //     ? ""
                                                  //     :
                                                  "Hold for 5 Seconds to Send Alert!"
                                                  : "Sending Alert in ${time.seconds.inSeconds}",
                                              style: AppTextStyles.kPrimaryS9W1
                                                  .copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                            //   Obx(
                                            // () {
                                            // if (controller.isAlertSent.value) {
                                            //   return Text(
                                            //     "Emergency Help Has Been Contacted!",
                                            //     textAlign: TextAlign.center,
                                            //     style:
                                            //         AppTextStyles.kPrimaryS9W1.copyWith(
                                            //       fontSize: 16,
                                            //     ),
                                            //   );
                                            // }
                                            //   return Text(
                                            //     time == 6.0
                                            //         ? "Hold for 5 Seconds to Send Alert!"
                                            //         : "Sending alert in ${time.seconds.inSeconds}",
                                            //     style: AppTextStyles.kPrimaryS9W1
                                            //         .copyWith(
                                            //       fontSize: 16,
                                            //     ),
                                            //   );
                                            // },
                                            //),
                                            interval: const Duration(
                                                milliseconds: 100),
                                            onFinished: () {
                                              Get.find<
                                                      TransactionAlertController>()
                                                  .startButtonAnimation(
                                                      alertType);
                                            },
                                          );
                                  }),
                                  SizedBox(
                                    height: SizeConfig.heightMultiplier * 0.06,
                                  ),
                                  controller.isAnimating
                                      ? const MENAlertAnimation()
                                      : MenAlertOffContainer(
                                          onPressed: () {
                                            controller.isAlertSent.value =
                                                false;
                                            controller.update();
                                            countdownController?.pause();
                                            countdownController?.restart();
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// todo: mara da ba wrasara hm bia esta enable ke
                      // Visibility(
                      //   visible: myAppUser.isSubscriptionExpired == null ||
                      //       myAppUser.isSubscriptionExpired == true,
                      //   child: Center(
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         Get.toNamed(Routes.PLANS);
                      //       },
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Image.asset(
                      //             'assets/subscribe_first.png',
                      //             fit: BoxFit.contain,
                      //             height: 160,
                      //             width: 210,
                      //           ),
                      //           const SizedBox(
                      //             height: 6,
                      //           ),
                      //           const Text(
                      //             'Subscribe to Use',
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.w500,
                      //               color: Colors.white,
                      //               fontSize: 15,
                      //             ),
                      //
                      //           ),
                      //           const SizedBox(
                      //             height: 30,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}

class EmergencyItemCircle extends StatelessWidget {
  final String title;
  final Function(String) onTap;
  final bool isSelected;

  const EmergencyItemCircle(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap(title),
      child: Container(
        height: SizeConfig.heightMultiplier * 15.05,
        width: SizeConfig.widthMultiplier * 32.38,
        decoration: BoxDecoration(
            color: isSelected ? AppColors.selectedContainerColor : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.selectedContainerColor
                    : Colors.white,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0.3, 0.5),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                _getCardIcon(title),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              _getTitle(title),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCardIcon(String type) {
    type = type.toLowerCase();
    if (type == "firebrigade") {
      return 'assets/svg_icons/firefighter.png';
    } else if (type == "police") {
      return 'assets/svg_icons/police-car.png';
    } else if (type == "coast guard") {
      return 'assets/svg_icons/coast-guard.png';
    } else {
      return 'assets/svg_icons/ambulance.png';
    }
  }

  String _getTitle(String type) {
    type = type.toLowerCase();
    if (type == "firebrigade") {
      return "Fire";
    } else if (type == "police") {
      return "Police";
    } else if (type == "coast guard") {
      return "Coast Guard";
    } else {
      return "Ambulance";
    }
  }
}
