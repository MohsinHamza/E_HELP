import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';
import 'package:getx_skeleton/app/services/logger_services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../utils/firebasepaths.dart';
import '../components/custom_snackbar.dart';
import '../components/webview_widget.dart';
import '../data/local/price_model.dart';
import '../data/models/payment_intent_model.dart';
import 'my_app_user.dart';

abstract class Payment {
  ///Processes payment, show intent according to doc listening... return callback [OnPaymentSuccessCallBack]
  processPayment({required String amount, onPaymentSuccessCallBack, onStartPayment});

  ///It listens to changes in newly created document because cloud will change document to get us required feilds to generate intent.
  sniffDocumentChanges({required String docId, required onPaymentSuccessCallBack, onStartPayment});

  ///Shows Sheet Bottom for Mobile.... and Shows Sheet Bottom for Web
  initPaymentSheet();
}

class SubscriptionPaymentController extends GetxService with Payment {
  static SubscriptionPaymentController get find => Get.find<SubscriptionPaymentController>();

  static SubscriptionPaymentController get create => Get.put(SubscriptionPaymentController());

  ///To Dispose listener for better performance...
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? firestoreDocListener;

  //mobile native view
  initPaymentSchedule({String? customerId, PriceModel? priceModel, int? startDate, onPaymentSuccessCallBack}) async {
    CustomSnackBar.showPreloader();
    // functions.showPreloader();

    try {
      int? price = priceModel?.price;
      //check if discounts exists
      if (await FirebaseFirestoreService.find.isDiscountEligible()) {
        price = (priceModel!.price - 500);
      }

      // 1. create payment intent on the server
      final response = await http.post(
        Uri.parse('https://us-central1-medical-emergency-network.cloudfunctions.net/createIntentPayment'),
        body: {'customerId': customerId, 'amount': price.toString()},
      );

      if (response.statusCode == 404) {
        await http.post(
          Uri.parse('https://us-central1-medical-emergency-network.cloudfunctions.net/fillStripeDetailsToUserDocument'),
          body: {'userId': MyAppUser.find.id, 'email': MyAppUser.find.email},
        );

        CustomSnackBar.showCustomErrorToast(message: "There is something wrong with generating payment intent, please try again or contact admin support.");
      }

      final jsonResponse = jsonDecode(response.body);

      print(jsonResponse);
      // LoggerServices.find.logD("***inititing payment apple pay****");
      // await Stripe.instance.presentApplePay(
      //   ApplePayPresentParams(
      //     cartItems: [
      //       ApplePayCartSummaryItem.recurring(
      //           label: priceModel!.priceName.toString(),
      //           amount: price.toString(),
      //           intervalCount: 1,
      //           intervalUnit: ApplePayIntervalUnit.month),
      //     ],
      //     country: 'us',
      //     currency: 'usd',
      //   ),
      // );

      // await Stripe.instance.initPaymentSheet(
      //     paymentSheetParameters: SetupPaymentSheetParameters(
      //   // Main params
      //   paymentIntentClientSecret: jsonResponse['paymentIntent'],
      //   merchantDisplayName: 'Medical Emergency Network',
      //   customerId: jsonResponse['customer'],
      //   customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      //   style: ThemeMode.light,
      //   appearance:
      //       const PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(background: Colors.white, primary: AppColors.lightRed)),
      // ));
      CustomSnackBar.hidePreloader();
      //await Stripe.instance.presentPaymentSheet();
      CustomSnackBar.showPreloader();
      final response2 = await http.post(
        Uri.parse('https://us-central1-medical-emergency-network.cloudfunctions.net/startSubscription'),
        body: {'customerId': customerId, 'priceId': priceModel?.price ?? "", 'start_date': (startDate! / 1000).toStringAsFixed(0)},
      );

      if (response2.statusCode == 200) {
        ///remove 1 entry of 5 discount from user
        FirebaseFirestoreService.find.discountRemove();
        onPaymentSuccessCallBack();
      } else {
        CustomSnackBar.showCustomErrorToast(title: "Error", message: "Please contact support dashboard to resolve this issue");
      }
      CustomSnackBar.hidePreloader();
      CustomSnackBar.hidePreloader();
      CustomSnackBar.hidePreloader();
      LoggerServices.find.logD(response2.body);
      return true;
    } catch (e) {
      CustomSnackBar.hidePreloader();
      // if (e is StripeException) {
      //   CustomSnackBar.showCustomErrorToast(title: "Cancelled", message: e.error.localizedMessage.toString());
      // } else if (e is FormatException) {
      //   debugPrint(e.message);
      //   CustomSnackBar.showCustomErrorToast(title: "Server Down", message: "Server Down, Please try again later");
      // } else {
      //   debugPrint(e.toString());
      //   CustomSnackBar.showCustomErrorToast(title: "Server Down", message: "Something went wrong!, Try later.");
      // }
    }
  }

  //web view
  @override
  initPaymentSheet({String? url, contactModel, onPaymentSuccessCallBack}) {
    if (url != null) {
      Get.to(WebViewWidget0(url: url, contactModel: contactModel, onPaymentSuccessCallBack: onPaymentSuccessCallBack));
    }
  }

  @override
  processPayment({String? amount, onPaymentSuccessCallBack, onStartPayment, PriceModel? priceModel, ContactModel? model}) async {
    CustomSnackBar.showPreloader();
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebasePath.userC.doc(FirebaseAuth.instance.currentUser!.uid).collection("checkout_sessions").doc(docId).set(
      {
        "line_items": {
          "0": {"price": priceModel?.price, "quantity": "1"}
        },
        "phases": {
          "0": {
            // "end_date": "1675105200",
            "items": {
              "0": {"price": priceModel?.price, "quantity": "1", "currency": "usd"}
            },
            "invoice_settings": {"description": "asdasd"},
            "collection_method": "charge_automatically"
          }
        },
        "allow_promotion_codes": true,
        "metadata": {"contactModel": model?.toJson().toString(), "number": model?.phoneNumber, "for": "pay for a friend or family"},
        "success_url": "https://success.com",
        "cancel_url": "https://cancel.com",
        "docId": docId,
      },
      //TODO:IMP
      /*     {
        "price": isMonthly ? monthlySubscriptionId : yearlySubscriptionId,
        "success_url": "https://success.com",
        "cancel_url": "https://cancel.com",
        "docId": docId,
      },*/
    );
    sniffDocumentChanges(docId: docId, onPaymentSuccessCallBack: onPaymentSuccessCallBack, onStartPayment: onStartPayment, contact: model);
  }

  @override
  sniffDocumentChanges({required String docId, required onPaymentSuccessCallBack, onStartPayment, contact}) {
    debugPrint("Sniff called");
    try {
      Stream<DocumentSnapshot<Map<String, dynamic>>> docChanges = FirebasePath.userC.doc(FirebaseAuth.instance.currentUser!.uid).collection("checkout_sessions").doc(docId).snapshots();
      firestoreDocListener = docChanges.listen((event) {
        if (event.data()?["error"] != null) {
          Get.back();
          Map errorData = event.data()?["error"];
          CustomSnackBar.showCustomErrorSnackBar(title: "Payment not completed", message: errorData["message"].toString());
          return;
        }
        String? url = event.data()?["url"];
        if (url == null || url == "") return;
        CustomSnackBar.hidePreloader();
        initPaymentSheet(url: url, contactModel: contact, onPaymentSuccessCallBack: onPaymentSuccessCallBack);
      });
    } catch (e) {
      Logger().e(e);
    }
  }
}

class SinglePaymentController extends GetxService with Payment {
  static SinglePaymentController get find => Get.find<SinglePaymentController>();

  static SinglePaymentController get create => Get.put(SinglePaymentController());

  ///To Dispose listener for better performance...
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? firestoreDocListener;

  @override
  initPaymentSheet({PaymentIntentModel? intentModel, callback, cancelStream, onStartPayment, bool isMonthly = true}) async {
    try {
      print("initPaymentSheet called");
      onStartPayment != null ? onStartPayment() : null;
      // 2. initialize the payment sheet
      await _paymentSheetWork(intentModel, isMonthly: isMonthly);

      callback != null ? callback() : null;

      cancelStream != null ? cancelStream() : null;
    } catch (e) {
      CustomSnackBar.hidePreloader();
      // CustomSnackBar.showCustomErrorToast(
      //     title: e.error.code.name,
      //     message: e.error.message!.contains("Please check your internet "
      //             "connection and try again")
      //         ? "Please check your internet connection and try again"
      //         : e.error.message ?? "",
      //     duration: 4.seconds);
      print("=======?");
      print(e);
    } catch (e) {
      CustomSnackBar.hidePreloader();

      CustomSnackBar.showCustomErrorToast(title: "Error", message: "Please check your internet or try again later.", duration: 4.seconds);
    }
  }

  _paymentSheetWork(PaymentIntentModel? intentModel, {bool isMonthly = true}) async {
    if (Platform.isIOS) {
      // await Stripe.instance.presentApplePay(
      //   ApplePayPresentParams(
      //     cartItems: isMonthly
      //         ? [
      //             ApplePayCartSummaryItem.immediate(
      //                 label: 'Buy for 30 Days',
      //                 amount: Get.find<AppConfigController>().priceList.isNotEmpty
      //                     ? Get.find<AppConfigController>().priceList.first.price.toString()
      //                     : "15.00"),
      //           ]
      //         : [
      //             ApplePayCartSummaryItem.immediate(
      //                 label: 'Buy for 365 Days',
      //                 amount: Get.find<AppConfigController>().priceList.isNotEmpty
      //                     ? Get.find<AppConfigController>().priceList.last.price.toString()
      //                     : "150.00"),
      //           ],
      //     country: 'US',
      //     currency: 'USD',
      //   ),
      // );

      // 2. Confirm apple pay payment
      //await Stripe.instance.confirmApplePayPayment(intentModel?.paymentIntentClientSecret ?? "");
      //done apple pay.
      return;
    } else {
      // await Stripe.instance.initPaymentSheet(
      //     paymentSheetParameters: SetupPaymentSheetParameters(
      //   paymentIntentClientSecret: intentModel?.paymentIntentClientSecret,
      //   merchantDisplayName: 'Medical Emergency Network',
      //   // Customer params
      //   customerId: intentModel?.customerId,
      //   customerEphemeralKeySecret: intentModel?.customerEphemeralKeySecret,
      //   // Extra params
      //   // applePay: const PaymentSheetApplePay(merchantCountryCode: 'US', testEnv: true),
      //   // googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US', testEnv: true),
      //   style: ThemeMode.light,
      //   appearance:
      //       const PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(background: Colors.white, primary: AppColors.lightRed)),
      // ));
      //await Stripe.instance.presentPaymentSheet();
    }
  }

  @override
  processPayment({required String amount, onPaymentSuccessCallBack, onStartPayment, String? toNumber, ContactModel? contactModel, bool isMonthly = true}) async {
    CustomSnackBar.showPreloader();
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebasePath.userC.doc(FirebaseAuth.instance.currentUser!.uid).collection("checkout_sessions").doc(docId).set(
      {
        "docId": docId,
        "client": "mobile",
        "toNumber": toNumber,
        "mode": "payment",
        "amount": amount,
        "currency": "usd",
        // "discounts": [
        //   {
        //     "coupon": 'H3tyH4xv',
        //   }
        // ],
        "metadata": {"contactModel": contactModel?.toJson().toString(), "number": contactModel?.phoneNumber, "for": contactModel == null ? "myself" : "pay for a friend or family"},
        "contactModel": contactModel?.toJson(),
      },
    );
    sniffDocumentChanges(docId: docId, onPaymentSuccessCallBack: onPaymentSuccessCallBack, onStartPayment: onStartPayment, isMonthly: isMonthly);
  }

  @override
  sniffDocumentChanges({required String docId, required onPaymentSuccessCallBack, onStartPayment, bool isMonthly = true}) async {
    debugPrint("Sniff called");
    try {
      Stream<DocumentSnapshot<Map<String, dynamic>>> docChanges = FirebasePath.userC.doc(FirebaseAuth.instance.currentUser!.uid).collection("checkout_sessions").doc(docId).snapshots();
      firestoreDocListener = docChanges.listen((event) {
        Map eventData = event.data() as Map;
        //avoid extra calls when there is changes in doc.
        if (eventData["ephemeralKeySecret"] == null && eventData["status"] == true) return;
        print("data event: ${event.data()}");
        PaymentIntentModel model = PaymentIntentModel.fromSnapshot(event);
        CustomSnackBar.hidePreloader();
        initPaymentSheet(
            isMonthly: isMonthly,
            intentModel: model,
            callback: onPaymentSuccessCallBack,
            onStartPayment: onStartPayment,
            cancelStream: () {
              firestoreDocListener?.cancel();
              firestoreDocListener = null;
            });
      });
    } catch (e) {
      Logger().e(e);
    }
  }
}
