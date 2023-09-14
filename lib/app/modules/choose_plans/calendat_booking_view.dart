import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme/apptextstyles.dart';
import '../../../config/theme/custom_app_colors.dart';
import '../../../utils/DateFormate_utils.dart';
import '../../services/in_app_purchases_service.dart';

class CalendarPaymentBuyPage extends StatefulWidget {
  final bool isFromExpired;
  final bool isYearSelectedTab;

  const CalendarPaymentBuyPage(
      {Key? key, this.isFromExpired = false, this.isYearSelectedTab = false})
      : super(key: key);

  @override
  State<CalendarPaymentBuyPage> createState() => _CalendarPaymentBuyPageState();
}

class _CalendarPaymentBuyPageState extends State<CalendarPaymentBuyPage> {
  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  bool isMonth = true;
  bool isUniqueKey = false;

  bool isYearTabSelected = false;

  bool _isLoading = false;

  toggle(bool isMonth) {
    isUniqueKey = true;

    if (!isMonth) {
      _rangeStart = null;
      _rangeEnd = null;
      startDate = DateTime.now();
      endDate = DateTime(startDate.year, startDate.month + 1, startDate.day);
      // endDate = DateTime.now().add(const Duration(days: 30));
      _selectedDay = startDate;
      _rangeStart = startDate;
      _rangeEnd = endDate;
      isMonth = true;
      isYearTabSelected = false;
    } else {
      _rangeStart = null;
      _rangeEnd = null;
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(days: 364));
      isMonth = false;
      isYearTabSelected = true;
      _selectedDay = startDate;
      _rangeStart = startDate;
      _rangeEnd = endDate;
    }
    setState(() {});
  }

  onDayChanged(selectedDay, focusedDay) {
    if (isSameDay(selectedDay, focusedDay)) {
      _rangeStart = null; // Important to clean those
      _rangeEnd = null;
      setState(
        () {
          _selectedDay = selectedDay;
          _focusedDay = selectedDay;
          _rangeStart = _selectedDay;
          startDate = selectedDay;

          if (isMonth) {
            _rangeEnd = DateTime(
                _rangeStart!.year, _rangeStart!.month + 1, _rangeStart!.day);
            endDate = DateTime(
                _rangeStart!.year, _rangeStart!.month + 1, _rangeStart!.day);
            isMonth = true;
          } else {
            _rangeEnd = DateTime.now().add(
              const Duration(
                days: 364,
              ),
            );
            endDate =
                DateTime(_rangeEnd!.year, _rangeEnd!.month, _rangeEnd!.day);
            isMonth = false;
          }
        },
      );
    }
  }

  @override
  void initState() {
    isUniqueKey = true;
    isMonth = widget.isYearSelectedTab ? false : true;
    if (isMonth) {
      _rangeStart = null;
      _rangeEnd = null;
      startDate = DateTime.now();
      endDate = DateTime(startDate.year, startDate.month + 1, startDate.day);
      _selectedDay = startDate;
      _rangeStart = startDate;
      _rangeEnd = endDate;
      isMonth = true;
      isYearTabSelected = false;
    } else {
      _rangeStart = null;
      _rangeEnd = null;
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(days: 364));
      isMonth = false;
      isYearTabSelected = true;
      _selectedDay = startDate;
      _rangeStart = startDate;
      _rangeEnd = endDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // toolbarHeight: 0,
      ),
      drawer: widget.isFromExpired ? null : const CustomDrawer(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SlidingSwitch(
                  value: !isMonth,
                  width: 250,
                  onChanged: toggle,
                  height: 55,
                  colorOn: Theme.of(context).primaryColor,
                  colorOff: Theme.of(context).primaryColor,
                  background: Colors.grey.shade600,
                  buttonColor: Colors.white,
                  inactiveColor: Colors.grey,
                  animationDuration: const Duration(milliseconds: 100),
                  onTap: toggle,
                  onDoubleTap: () {},
                  onSwipe: () {},
                  textOff: "Month",
                  textOn: "Year",
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * .66,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 12),
                        height: MediaQuery.of(context).size.height * .66,
                        width: MediaQuery.of(context).size.width,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.redAccent, // <-- SEE HERE
                              onPrimary: Colors.white, // <-- SEE HERE
                              onSurface: Colors.black, // <-- SEE HERE
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                primary: Colors.red, // button text color
                              ),
                            ),
                          ),
                          child: TableCalendar(
                            key: isUniqueKey ? UniqueKey() : null,
                            calendarStyle: CalendarStyle(
                              rangeHighlightColor:
                                  Colors.redAccent.withOpacity(0.2),
                              rangeStartDecoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              rangeEndDecoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: const HeaderStyle(
                              titleCentered: true,
                              formatButtonVisible: false,
                            ),
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(
                              const Duration(
                                days: 364,
                              ),
                            ),
                            calendarBuilders: CalendarBuilders(
                              todayBuilder: (context, date1, date2) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                    left: 13.5,
                                    top: 13.5,
                                    right: 13.5,
                                    bottom: 18.3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    date1.day.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              selectedBuilder: (context, date1, date2) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                    left: 13.5,
                                    top: 13.5,
                                    right: 13.5,
                                    bottom: 18.3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    date1.day.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            rangeStartDay: _rangeStart,
                            rangeEndDay: _rangeEnd,
                            calendarFormat: _calendarFormat,
                            rangeSelectionMode: RangeSelectionMode.toggledOn,
                            onDaySelected: onDayChanged,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                          left: 14,
                          top: 15,
                          bottom: 16,
                        ),
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${CustomeDateFormate.DDMMMMDDDD(startDate)}",
                                  style: AppTextStyles.kPrimaryS9W3,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 29.0,
                              ),
                              child: Divider(
                                height: 2,
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${CustomeDateFormate.DDMMMMDDDD(endDate)}",
                                  style: AppTextStyles.kPrimaryS9W3,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // const Spacer(),
              const SizedBox(height: 15),
              //Pay via stripe or ApplePay
              payButtonWidget()
            ],
          ),
        ),
      ),
    );
  }

  payButtonWidget() {
    //todo: implement the correct code with in app purchases
    // if (Platform.isIOS) {
    //   //ios pay
    //   int difference = endDate.difference(startDate).inDays;
    //   bool isMonth = difference >= 28 && difference <= 31;
    //   return ApplePayButton(
    //     onPressed: () {},
    //     paymentConfigurationAsset: '',
    //     onPaymentResult: (Map<String, dynamic> result) {},
    //     paymentItems: [],
    //   );
    // } else {
    return Container(
      padding: const EdgeInsets.only(
        left: 21,
        right: 21,
      ),
      // height: MediaQuery.of(context).size.height * .08,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 5,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            AppColors.Kblue_type,
          ),
        ),
        onPressed: () async {
          // if (Get.find<ChoosePlanController>().availablePackages.isEmpty) {
          //   // showDialog(context: context, builder: (_){
          //   //   return AlertDialog(
          //   //     content: Container(
          //   //
          //   //     ),
          //   //   );
          //   // });
          //   Get.dialog(
          //     Container(
          //       padding: const EdgeInsets.all(4),
          //
          //       decoration: const BoxDecoration(
          //         color: Colors.white,
          //         shape: BoxShape.circle,
          //       ),
          //       height: 45,
          //       width: 45,
          //       child: const CircularProgressIndicator(),
          //     ),
          //   );
          //
          //   //await PurchasesApi.fetchOffers();
          //   Get.back();
          // }
          // bool isMonth = isYearTabSelected ? false : true;
          // Package package = isMonth
          //     ? Get.find<ChoosePlanController>().availablePackages[0]
          //     : Get.find<ChoosePlanController>().availablePackages[1];
          // bool isPurchased =
          //     await PurchasesApi.purchasePackage(package, endDate, startDate);
          //if (isPurchased) {
          Get.offAllNamed(Routes.HOME);
          //}
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
          ),
          child: Center(
            child: Text(
              "Confirm",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
    //}
  }

  // payButtonWidget() {
  //   //todo: implement the correct code with in app purchases
  //   if (Platform.isIOS) {
  //     //ios pay
  //     int difference = endDate.difference(startDate).inDays;
  //     bool isMonth = difference >= 28 && difference <= 31;
  //     return ApplePayButton(
  //       onPressed: validate,
  //       paymentConfigurationAsset: '',
  //       onPaymentResult: (Map<String, dynamic> result) {},
  //       paymentItems: [],
  //     );
  //     // return pay.ApplePayButton(
  //     //   paymentConfigurationAsset: 'applepay.json',
  //     //   paymentItems: isMonth
  //     //       ? [
  //     //           pay.PaymentItem(
  //     //               label: 'Buy for 30 days',
  //     //               amount: Get.find<AppConfigController>().priceList.isNotEmpty
  //     //                   ? Get.find<AppConfigController>().priceList.first.price.toString()
  //     //                   : "15.00")
  //     //         ]
  //     //       : [
  //     //           pay.PaymentItem(
  //     //               label: 'Buy for 365 days',
  //     //               amount: Get.find<AppConfigController>().priceList.isNotEmpty
  //     //                   ? Get.find<AppConfigController>().priceList.last.price.toString()
  //     //                   : "150.00")
  //     //         ],
  //     //   width: 200,
  //     //   height: 50,
  //     //   style: pay.ApplePayButtonStyle.black,
  //     //   type: pay.ApplePayButtonType.buy,
  //     //   margin: const EdgeInsets.only(top: 15.0),
  //     //   onPaymentResult: (paymentResult) {
  //     //     _onPaymentResult(paymentResult, isMonthly: isMonth);
  //     //   },
  //     //   loadingIndicator: const Center(child: CircularProgressIndicator.adaptive()),
  //     // );
  //   } else {
  //     //Stripe payment
  //     return Container(
  //       padding: const EdgeInsets.only(left: 21, right: 21),
  //       // height: MediaQuery.of(context).size.height * .08,
  //       width: MediaQuery.of(context).size.width,
  //       margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
  //       child: ElevatedButton(
  //         style: ButtonStyle(
  //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                 RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(5.0))),
  //             backgroundColor:
  //                 MaterialStateProperty.all<Color>(AppColors.Kblue_type)),
  //         onPressed: validate,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 0),
  //           child: Text(
  //             isYearTabSelected
  //                 ? "Confirm Yearly Subscription"
  //                 : "Confirm 30 Days Subscription",
  //             style: const TextStyle(
  //               fontSize: 17,
  //               fontWeight: FontWeight.w900,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  // _onPaymentResult(paymentResult, {required bool isMonthly}) async {
  //   final response = await fetchPaymentIntentClientSecret();
  //   final clientSecret = response['clientSecret'];
  //   final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
  //   final tokenJson = Map.castFrom(json.decode(token));
  //
  //   final params = PaymentMethodParams.cardFromToken(
  //       paymentMethodData: PaymentMethodDataCardFromToken(
  //           token: tokenJson['id']
  //       )
  //   );
  //   // Confirm Google pay payment method
  //   await Stripe.instance.confirmPayment(
  //     clientSecret,
  //     params,
  //   );
  // }

  // onMonthlySubscription(int difference) async {
  //   int? price = Get.find<AppConfigController>().priceList.first.price;
  //   //check if discounts exists
  //   if (await FirebaseFirestoreService.find.isDiscountEligible()) {
  //     price = (Get.find<AppConfigController>().priceList.first.price - 500);
  //   }
  //   SinglePaymentController.create.processPayment(
  //       amount: price.toString(),
  //       isMonthly: true,
  //       contactModel: null,
  //       toNumber: null,
  //       onPaymentSuccessCallBack: () async {
  //         FirebaseFirestoreService.find.discountRemove();
  //         await Get.find<FirebaseFirestoreService>()
  //             .updateSubscriptionStatus(days: 30);
  //         CustomSnackBar.showCustomSnackBar(
  //             title: "Success",
  //             message:
  //                 "Great! You have successfully bought the monthly subscription");
  //         if (widget.isFromExpired) {
  //           Get.offAllNamed(AppPages.INITIAL);
  //         }
  //       });
  // }
  //
  // onYearlySubscription() async {
  //   int? price = Get.find<AppConfigController>().priceList.last.price;
  //   //check if discounts exists
  //   if (await FirebaseFirestoreService.find.isDiscountEligible()) {
  //     price = (Get.find<AppConfigController>().priceList.last.price - 500);
  //   }
  //   SinglePaymentController.create.processPayment(
  //       amount: price.toString(),
  //       contactModel: null,
  //       toNumber: null,
  //       isMonthly: false,
  //       onPaymentSuccessCallBack: () async {
  //         FirebaseFirestoreService.find.discountRemove();
  //         await Get.find<FirebaseFirestoreService>()
  //             .updateSubscriptionStatus(days: 365);
  //         CustomSnackBar.showCustomSnackBar(
  //             title: "Success",
  //             message:
  //                 "Great! You have successfully bought the yearly subscription");
  //         if (widget.isFromExpired) {
  //           Get.offAllNamed(AppPages.INITIAL);
  //         }
  //       });
  // }
  //
  // validate() async {
  //   // if (Get.find<AppConfigController>().priceList.isEmpty) {
  //   //   CustomSnackBar.showCustomErrorToast(
  //   //       message: "There is no price list available, Please try again later or contact support admin", duration: 5.seconds);
  //   //   Get.snackbar("Error", "There is no price list available, Please try again later or contact support admin");
  //   //   return;
  //   // }
  //
  //   MyAppUser user = await Get.find<FirebaseFirestoreService>()
  //       .loadMyAppUserData(FirebaseAuth.instance.currentUser!.uid);
  //
  //   MyAppUser.find.update(user);
  //
  //   int difference = endDate.difference(startDate).inDays;
  //   //print(await Get.find<ChoosePlanController>().selectedPackage!.toMap());
  //   // if (difference >= 28 && difference <= 31) {
  //   //   onMonthlySubscription(difference);
  //   //   // var resp = await SubscriptionPaymentController.create.initPaymentSchedule(
  //   //   //     customerId: MyAppUser.find.stripeId ?? "",
  //   //   //     priceModel: Get.find<AppConfigController>().priceList.first,
  //   //   //     startDate: startDate.millisecondsSinceEpoch,
  //   //   //     onPaymentSuccessCallBack: () {
  //   //   //       print("SUCCESS MONTHLY");
  //   //   //     });
  //   //   // if (resp != null) {
  //   //   //   await Get.find<FirebaseFirestoreService>().updateSubscriptionStatus(days: difference);
  //   //   //   CustomSnackBar.showCustomSnackBar(title: "Success", message: "Great! You have successfully bought the monthly subscription");
  //   //   //   if (widget.isFromExpired) {
  //   //   //     Get.offAllNamed(AppPages.INITIAL);
  //   //   //   }
  //   //   // }
  //   // }
  //   // else if (difference >= 363 && difference <= 366) {
  //   //   LoggerServices.find.logError("YEAR CASE");
  //   //   onYearlySubscription();
  //   //   // print(Get.find<AppConfigController>().priceList);
  //   //   // var resp = await SubscriptionPaymentController.create.initPaymentSchedule(
  //   //   //     customerId: MyAppUser.find.stripeId ?? "",
  //   //   //     priceModel: Get.find<AppConfigController>().priceList.last,
  //   //   //     startDate: startDate.millisecondsSinceEpoch,
  //   //   //     onPaymentSuccessCallBack: () {
  //   //   //       print("SUCCESS Yearly");
  //   //   //     });
  //   //   //
  //   //   // if (resp != null) {
  //   //   //   await Get.find<FirebaseFirestoreService>().updateSubscriptionStatus(days: 365);
  //   //   //   CustomSnackBar.showCustomSnackBar(title: "Success", message: "Great! You have successfully bought the yearly subscription");
  //   //   //   if (widget.isFromExpired) {
  //   //   //     Get.offAllNamed(AppPages.INITIAL);
  //   //   //   }
  //   //   // }
  //   // } else {
  //   //   LoggerServices.find.logError("ERRRRRRRRRRRRRRROR ELSE CASE");
  //   //
  //   //   CustomSnackBar.showCustomErrorSnackBar(
  //   //       title: "Please select a valid date range.", message: "Minimum 1 month and Max 1 Year of date selection is allowed");
  //   // }
  // }
}

class ScheduleCalendarScreen extends StatelessWidget {
  const ScheduleCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingSwitch(
        value: false,
        width: 250,
        onChanged: (bool value) {
          print(value);
        },
        height: 55,
        animationDuration: const Duration(milliseconds: 400),
        onTap: () {},
        onDoubleTap: () {},
        onSwipe: () {},
        textOff: "Month",
        textOn: "Year",
        colorOn: Theme.of(context).primaryColor,
        colorOff: Theme.of(context).primaryColor,
        background: const Color(0xffe4e5eb),
        buttonColor: const Color(0xfff7f5f7),
        inactiveColor: const Color(0xff636f7b),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {Key? key, required this.title, this.iconData, required this.onPressed})
      : super(key: key);
  final String title;
  final String? iconData;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.montserrat(
            fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      leading: iconData == null
          ? const Icon(Icons.person)
          : Image.asset('assets/svg_icons/$iconData'),
      onTap: onPressed,
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: 290,
        child: Drawer(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Image.asset(
                  "assets/icons/men_logo.png",
                  height: 100,
                ),
              ),
              const SizedBox(height: 25,),
              const Divider(),
              DrawerTile(
                title: "Profile",
                onPressed: () {
                  Get.toNamed(Routes.PROFILE);
                },
              ),
              DrawerTile(
                iconData: 'appuse.png',
                title: "App Use",
                onPressed: () async {
                  try {
                    await _launchUrl(
                        'https://medicalemergencynetwork.com/app-use/');
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              DrawerTile(
                iconData: 'myevidence.png',
                title: "My Evidences",
                onPressed: () async {
                  Get.toNamed(Routes.MYEVIDENCES);
                },
              ),
              DrawerTile(
                iconData: 'contacts.png',
                title: "Emergency Contacts",
                onPressed: () async {
                  Get.toNamed(Routes.CONTACTS);
                },
              ),
              DrawerTile(
                iconData: 'mysubscriptions.png',
                title: "My Subscription",
                onPressed: () async {
                  //PurchasesApi.cancelSubscription(context);
                },
              ),
              DrawerTile(
                iconData: 'howtouse.png',
                title: "How to Use the Button",
                onPressed: () async {
                  Get.toNamed(Routes.HOW_TO_USE_APP);
                },
              ),
              DrawerTile(
                iconData: 'Vector-4.png',
                title: "Refer a friend",
                onPressed: () async {
                  Get.toNamed(Routes.INVITE);
                },
              ),
              DrawerTile(
                iconData: 'customer_care.png',
                title: "Customer Service",
                onPressed: () async {
                  Get.toNamed(Routes.FEEDBACK);
                },
              ),
              DrawerTile(
                iconData: 'seeyourid.png',
                title: "See Your ID",
                onPressed: () async {
                  Get.toNamed(Routes.SEEYOURID);
                },
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomDatePicker extends StatefulWidget {
//   CustomDatePicker(
//       {Key? key,
//       required this.isUniqueKey,
//       required this.startDate,
//       required this.isMonth,
//       required this.endDate})
//       : super(key: key);
//   final bool isUniqueKey;
//   final DateTime startDate;
//   final DateTime endDate;
//   bool isMonth;
//   @override
//   State<CustomDatePicker> createState() => _CustomDatePickerState();
// }
//
// class _CustomDatePickerState extends State<CustomDatePicker> {
//   final CalendarFormat _calendarFormat = CalendarFormat.month;
//   final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   final kFirstDay =
//       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//   final kLastDay = DateTime(
//       DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 16, right: 12),
//       height: MediaQuery.of(context).size.height * .58,
//       width: MediaQuery.of(context).size.width,
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(
//             primary: Colors.redAccent, // <-- SEE HERE
//             onPrimary: Colors.white, // <-- SEE HERE
//             onSurface: Colors.black, // <-- SEE HERE
//           ),
//           textButtonTheme: TextButtonThemeData(
//             style: TextButton.styleFrom(
//               primary: Colors.red, // button text color
//             ),
//           ),
//         ),
//         child: TableCalendar(
//           key: widget.isUniqueKey ? UniqueKey() : null,
//           calendarStyle: CalendarStyle(
//             rangeHighlightColor: Colors.redAccent.withOpacity(0.2),
//             rangeStartDecoration: BoxDecoration(
//               color: Colors.redAccent.withOpacity(0.3),
//               shape: BoxShape.circle,
//             ),
//             rangeEndDecoration: BoxDecoration(
//               color: Colors.redAccent.withOpacity(0.6),
//               shape: BoxShape.circle,
//             ),
//           ),
//           headerStyle: const HeaderStyle(
//             titleCentered: true,
//             formatButtonVisible: false,
//           ),
//           firstDay: kFirstDay,
//           lastDay: kLastDay.add(
//             const Duration(
//               days: 364,
//             ),
//           ),
//           calendarBuilders:
//               CalendarBuilders(todayBuilder: (context, date1, date2) {
//             return Container(
//               padding: const EdgeInsets.only(
//                 left: 13.5,
//                 top: 13.5,
//                 right: 13.5,
//                 bottom: 18.3,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.redAccent.withOpacity(0.6),
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 date1.day.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             );
//           }, selectedBuilder: (context, date1, date2) {
//             return Container(
//               padding: const EdgeInsets.only(
//                 left: 13.5,
//                 top: 13.5,
//                 right: 13.5,
//                 bottom: 18.3,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent.withOpacity(0.6),
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 date1.day.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             );
//           }),
//           focusedDay: _focusedDay,
//           selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//           rangeStartDay: _rangeStart,
//           rangeEndDay: _rangeEnd,
//           calendarFormat: _calendarFormat,
//           rangeSelectionMode: _rangeSelectionMode,
//           onDaySelected: (selectedDay, focusedDay) {
//             setState(
//               () {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//                 _rangeStart = null; // Important to clean those
//                 _rangeEnd = null;
//                 if (widget.isMonth) {
//                   _rangeStart = _selectedDay;
//                   _rangeEnd = DateTime(_rangeStart!.year,
//                       _rangeStart!.month + 1, _rangeStart!.day);
//                 } else {
//                   _rangeStart = DateTime.now();
//                   _rangeEnd = DateTime.now().add(
//                     const Duration(
//                       days: 364,
//                     ),
//                   );
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
