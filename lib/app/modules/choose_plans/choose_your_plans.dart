// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:getx_skeleton/app/modules/choose_plans/plans_data.dart';
// import 'package:getx_skeleton/app/services/auth_firebase_services.dart';
// import 'package:getx_skeleton/app/services/in_app_purchases_service.dart';
// import '../../../config/theme/apptextstyles.dart';
// import '../../../config/theme/custom_app_colors.dart';
// import '../../components/reuseable_button.dart';
// import '../../controllers/choose_plan_controller.dart';
// import '../../routes/app_pages.dart';
// import '../auth/controller/auth_controller.dart';
// import '../auth/sign_in_screen.dart';
//
// class Choose_Your_PlansBindings extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ChoosePlanController>(() => ChoosePlanController());
//   }
// }
//
//
// class Choose_Your_Plans extends StatefulWidget {
//   const Choose_Your_Plans({Key? key}) : super(key: key);
//
//   @override
//   State<Choose_Your_Plans> createState() => _Choose_Your_PlansState();
// }
//
// class _Choose_Your_PlansState extends State<Choose_Your_Plans> {
//   bool isChecked = false;
//   //
//   // Future<void> onYearlySubscription() async {
//   //   await SubscriptionPaymentController.create.initPaymentSchedule(
//   //       customerId: MyAppUser.find.stripeId ?? "",
//   //       priceModel: Get.find<AppConfigController>().priceList.last,
//   //       startDate: DateTime.now().millisecondsSinceEpoch,
//   //       onPaymentSuccessCallBack: () {
//   //         print("SUCCESS Yearly");
//   //       });
//   // }
//   //
//   // Future<void> onMonthlySubscription() async {
//   //   int? price = Get.find<AppConfigController>().priceList.first.price;
//   //   //check if discounts exists
//   //   if (await FirebaseFirestoreService.find.isDiscountEligible()) {
//   //     price = (Get.find<AppConfigController>().priceList.first.price - 500);
//   //   }
//   //   SinglePaymentController.create.processPayment(
//   //       amount: price.toString(),
//   //       contactModel: null,
//   //       toNumber: null,
//   //       onPaymentSuccessCallBack: () {
//   //         FirebaseFirestoreService.find.discountRemove();
//   //
//   //         // Get.off( First_Chechkout(model: contact,));
//   //         // Get.to(Payment_page(2));
//   //       });
//   //
//   //   // await SubscriptionPaymentController.create.initPaymentSchedule(
//   //   //     customerId: MyAppUser.find.stripeId ?? "",
//   //   //     priceModel: Get.find<AppConfigController>().priceList.first,
//   //   //     startDate: DateTime.now().millisecondsSinceEpoch,
//   //   //     onPaymentSuccessCallBack: () {
//   //   //       print("SUCCESS Yearly");
//   //   //     });
//   // }
//   //
//   // Future<List<PriceModel>> future =
//   //     Get.find<FirebaseFirestoreService>().getPriceList();
//   bool monthSelected = true;
//   bool yearSelected = false;
//   bool selected = true;
//
//   String period = 'P1M';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   tooltip: "Logout",
//                   visualDensity: const VisualDensity(vertical: -4),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 10),
//                   onPressed: () {
//                     FirebaseAuthService().signOut();
//                     //PurchasesApi.logout();
//                     Get.off(const LoginScreen(),
//                         binding: AuthBindings());
//                   },
//                   icon: const Icon(
//                     Icons.logout,
//                     color: Colors.red,
//                     semanticLabel: "Logout",
//                   ),
//                 ),
//                 IconButton(
//                   tooltip: "Skip",
//                   visualDensity: const VisualDensity(vertical: -4),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 5,
//                     vertical: 10,
//                   ),
//                   onPressed: () {
//                     Get.toNamed(Routes.HOME);
//                   },
//                   icon: const Text(
//                     'Skip',
//                     style: TextStyle(
//                       fontSize: 17,
//                       color: AppColors.lightRed,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.only(left: 15.0, bottom: 10),
//               child: Text(
//                 "Choose Your Plan",
//                 style: AppTextStyles.kPrimaryS4W5.copyWith(
//                   fontSize: 25,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//
//                   return InkWell(
//                     onTap: () async {
//                       period =;
//                       if (model.storeProduct.subscriptionPeriod ==
//                           'P1M') {
//                         monthSelected = true;
//                         selected = true;
//                         yearSelected = false;
//                       } else {
//                         yearSelected = true;
//                         monthSelected = false;
//                         selected = true;
//                       }
//
//                     },
//                     child: Card(
//                       elevation: 12,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 2),
//                       child: Container(
//                         padding: const EdgeInsets.all(17),
//                         child: Column(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: 200,
//                                   height: 45,
//                                   child: Row(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         "\$14.99",
//                                         style: AppTextStyles
//                                             .kPrimaryS5W1
//                                             .copyWith(fontSize: 28),
//                                       ),
//                                       const Text(
//                                          '/yr',
//                                         style: AppTextStyles
//                                             .kPrimaryS7W1,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 GetBuilder<ChoosePlanController>(
//                                     builder: (con) {
//                                       return const Visibility(
//                                         visible: true,
//                                         child: RedRoundCheckBox(
//                                           isChecked: false,
//                                         ),
//                                       );
//                                     }),
//                               ],
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context)
//                                   .size
//                                   .width *
//                                   0.80,
//                               child: Text(
//                                 'Solo Monthly Plan',
//                                 maxLines: 1,
//                                 style: AppTextStyles.kPrimaryS8W3
//                                     .copyWith(
//                                   fontSize: 17,
//                                 ),
//                               ),
//                             ),
//                             // Text("\$${Get.find<AppConfigController>().priceList\first.price ?? 12}", style: AppTextStyles.kPrimaryS5W1),
//                             const SizedBox(height: 18),
//
//                             Expanded(
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: ListView.builder(
//                                   itemCount: model.storeProduct
//                                       .subscriptionPeriod ==
//                                       "P1M"
//                                       ? soloMonthlyFeatures.length
//                                       : soloYearlyFeatures.length,
//                                   itemBuilder: (context, index) {
//                                     String item = model.storeProduct
//                                         .subscriptionPeriod ==
//                                         "P1M"
//                                         ? soloMonthlyFeatures[index]
//                                         : soloYearlyFeatures[index];
//                                     return Padding(
//                                       padding: const EdgeInsets
//                                           .symmetric(vertical: 4.0),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           const Icon(
//                                             Icons
//                                                 .done_outline_rounded,
//                                             color: Colors.blue,
//                                           ),
//                                           const SizedBox(
//                                             width: 7,
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               item,
//                                               textAlign:
//                                               TextAlign.left,
//                                               maxLines: 2,
//                                               overflow: TextOverflow
//                                                   .ellipsis,
//                                               style: AppTextStyles
//                                                   .kPrimaryS5W2
//                                                   .copyWith(
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24.0,
//                 vertical: 10,
//               ),
//               child: Reuseable_button(
//                 "Next",
//                 AppColors.Kblue_type,
//                 SvgPicture.asset(""),
//                     () {
//                   Get.toNamed(
//                     Routes.BOOKINGS,
//                     parameters: {
//                       "isFromExpired": "true",
//                       "isMonthlySelected": monthSelected.toString(),
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         ///todo:previous code
//         // child: FutureBuilder<List<Offering>>(
//         //     future: PurchasesApi.fetchOffers(),
//         //     builder: (context, priceModelSnap) {
//         //       return priceModelSnap.connectionState == ConnectionState.waiting
//         //           ? const Center(child: CircularProgressIndicator.adaptive())
//         //           : Column(
//         //               crossAxisAlignment: CrossAxisAlignment.start,
//         //               children: [
//         //                 Row(
//         //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                   children: [
//         //                     IconButton(
//         //                       tooltip: "Logout",
//         //                       visualDensity: const VisualDensity(vertical: -4),
//         //                       padding: const EdgeInsets.symmetric(
//         //                           horizontal: 20, vertical: 10),
//         //                       onPressed: () {
//         //                         FirebaseAuthService().signOut();
//         //                         //PurchasesApi.logout();
//         //                         Get.off(const LoginScreen(),
//         //                             binding: AuthBindings());
//         //                       },
//         //                       icon: const Icon(
//         //                         Icons.logout,
//         //                         color: Colors.red,
//         //                         semanticLabel: "Logout",
//         //                       ),
//         //                     ),
//         //                     IconButton(
//         //                       tooltip: "Skip",
//         //                       visualDensity: const VisualDensity(vertical: -4),
//         //                       padding: const EdgeInsets.symmetric(
//         //                         horizontal: 5,
//         //                         vertical: 10,
//         //                       ),
//         //                       onPressed: () {
//         //                         Get.toNamed(Routes.HOME);
//         //                       },
//         //                       icon: const Text(
//         //                         'Skip',
//         //                         style: TextStyle(
//         //                           fontSize: 17,
//         //                           color: AppColors.lightRed,
//         //                           fontWeight: FontWeight.w600,
//         //                         ),
//         //                       ),
//         //                     ),
//         //                   ],
//         //                 ),
//         //                 Padding(
//         //                   padding:
//         //                       const EdgeInsets.only(left: 15.0, bottom: 10),
//         //                   child: Text(
//         //                     "Choose Your Plan",
//         //                     style: AppTextStyles.kPrimaryS4W5.copyWith(
//         //                       fontSize: 25,
//         //                     ),
//         //                     textAlign: TextAlign.center,
//         //                   ),
//         //                 ),
//         //                 Expanded(
//         //                   child: PageView.builder(
//         //                     itemCount: priceModelSnap
//         //                         .data![0].availablePackages.length,
//         //                     itemBuilder: (context, index) {
//         //                       final model = priceModelSnap
//         //                           .data![0].availablePackages[index];
//         //                       return InkWell(
//         //                         onTap: () async {
//         //                           period =
//         //                               model.storeProduct.subscriptionPeriod!;
//         //                           if (model.storeProduct.subscriptionPeriod ==
//         //                               'P1M') {
//         //                             monthSelected = true;
//         //                             selected = true;
//         //                             yearSelected = false;
//         //                           } else {
//         //                             yearSelected = true;
//         //                             monthSelected = false;
//         //                             selected = true;
//         //                           }
//         //                           Get.find<ChoosePlanController>()
//         //                               .assignNewPackage(model);
//         //                         },
//         //                         child: Card(
//         //                           elevation: 12,
//         //                           margin: const EdgeInsets.symmetric(
//         //                               horizontal: 20, vertical: 2),
//         //                           child: Container(
//         //                             padding: const EdgeInsets.all(17),
//         //                             child: Column(
//         //                               crossAxisAlignment:
//         //                                   CrossAxisAlignment.start,
//         //                               children: [
//         //                                 Row(
//         //                                   mainAxisAlignment:
//         //                                       MainAxisAlignment.spaceBetween,
//         //                                   children: [
//         //                                     SizedBox(
//         //                                       width: 200,
//         //                                       height: 45,
//         //                                       child: Row(
//         //                                         crossAxisAlignment:
//         //                                             CrossAxisAlignment.end,
//         //                                         children: [
//         //                                           Text(
//         //                                             "${model.storeProduct.currencyCode} ${model.storeProduct.price}",
//         //                                             style: AppTextStyles
//         //                                                 .kPrimaryS5W1
//         //                                                 .copyWith(fontSize: 28),
//         //                                           ),
//         //                                           Text(
//         //                                             model.storeProduct
//         //                                                         .subscriptionPeriod ==
//         //                                                     'P1M'
//         //                                                 ? '/mo'
//         //                                                 : '/yr',
//         //                                             style: AppTextStyles
//         //                                                 .kPrimaryS7W1,
//         //                                           ),
//         //                                         ],
//         //                                       ),
//         //                                     ),
//         //                                     GetBuilder<ChoosePlanController>(
//         //                                         builder: (con) {
//         //                                       return const Visibility(
//         //                                         visible: true,
//         //                                         child: RedRoundCheckBox(
//         //                                           isChecked: false,
//         //                                         ),
//         //                                       );
//         //                                     }),
//         //                                   ],
//         //                                 ),
//         //                                 SizedBox(
//         //                                   width: MediaQuery.of(context)
//         //                                           .size
//         //                                           .width *
//         //                                       0.80,
//         //                                   child: Text(
//         //                                     model.storeProduct.title,
//         //                                     maxLines: 1,
//         //                                     style: AppTextStyles.kPrimaryS8W3
//         //                                         .copyWith(
//         //                                       fontSize: 17,
//         //                                     ),
//         //                                   ),
//         //                                 ),
//         //                                 // Text("\$${Get.find<AppConfigController>().priceList\first.price ?? 12}", style: AppTextStyles.kPrimaryS5W1),
//         //                                 const SizedBox(height: 18),
//         //
//         //                                 Expanded(
//         //                                   child: Align(
//         //                                     alignment: Alignment.center,
//         //                                     child: ListView.builder(
//         //                                       itemCount: model.storeProduct
//         //                                                   .subscriptionPeriod ==
//         //                                               "P1M"
//         //                                           ? soloMonthlyFeatures.length
//         //                                           : soloYearlyFeatures.length,
//         //                                       itemBuilder: (context, index) {
//         //                                         String item = model.storeProduct
//         //                                                     .subscriptionPeriod ==
//         //                                                 "P1M"
//         //                                             ? soloMonthlyFeatures[index]
//         //                                             : soloYearlyFeatures[index];
//         //                                         return Padding(
//         //                                           padding: const EdgeInsets
//         //                                               .symmetric(vertical: 4.0),
//         //                                           child: Row(
//         //                                             crossAxisAlignment:
//         //                                                 CrossAxisAlignment
//         //                                                     .start,
//         //                                             children: [
//         //                                               const Icon(
//         //                                                 Icons
//         //                                                     .done_outline_rounded,
//         //                                                 color: Colors.blue,
//         //                                               ),
//         //                                               const SizedBox(
//         //                                                 width: 7,
//         //                                               ),
//         //                                               Expanded(
//         //                                                 child: Text(
//         //                                                   item,
//         //                                                   textAlign:
//         //                                                       TextAlign.left,
//         //                                                   maxLines: 2,
//         //                                                   overflow: TextOverflow
//         //                                                       .ellipsis,
//         //                                                   style: AppTextStyles
//         //                                                       .kPrimaryS5W2
//         //                                                       .copyWith(
//         //                                                     fontSize: 14,
//         //                                                   ),
//         //                                                 ),
//         //                                               ),
//         //                                             ],
//         //                                           ),
//         //                                         );
//         //                                       },
//         //                                     ),
//         //                                   ),
//         //                                 ),
//         //                               ],
//         //                             ),
//         //                           ),
//         //                         ),
//         //                       );
//         //                     },
//         //                   ),
//         //                 ),
//         //                 Padding(
//         //                   padding: const EdgeInsets.symmetric(
//         //                     horizontal: 24.0,
//         //                     vertical: 10,
//         //                   ),
//         //                   child: Reuseable_button(
//         //                     "Next",
//         //                     AppColors.Kblue_type,
//         //                     SvgPicture.asset(""),
//         //                     () {
//         //                       Get.toNamed(
//         //                         Routes.BOOKINGS,
//         //                         parameters: {
//         //                           "isFromExpired": "true",
//         //                           "isMonthlySelected": monthSelected.toString(),
//         //                         },
//         //                       );
//         //                     },
//         //                   ),
//         //                 ),
//         //               ],
//         //             );
//         //     }),
//       ),
//     );
//   }
// }
//
// class RedRoundCheckBox extends StatelessWidget {
//   const RedRoundCheckBox({Key? key, required this.isChecked}) : super(key: key);
//   final bool isChecked;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 38,
//       width: 38,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isChecked ? AppColors.Kblue_type : Colors.white,
//       ),
//       child: const Center(
//         child: Icon(
//           Icons.done,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
