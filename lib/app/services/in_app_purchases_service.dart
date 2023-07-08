

// enum Store { appleStore, googlePlay }
//
// class StoreConfig {
//   final Store store;
//   final String apiKey;
//   static StoreConfig? _instance;
//
//   factory StoreConfig({required Store store, required String apiKey}) {
//     _instance ??= StoreConfig._internal(store, apiKey);
//     return _instance!;
//   }
//
//   StoreConfig._internal(this.store, this.apiKey);
//
//   static StoreConfig get instance {
//     return _instance!;
//   }
//
//   static bool isForAppleStore() => _instance!.store == Store.appleStore;
//
//   static bool isForGooglePlay() => _instance!.store == Store.googlePlay;
// }

class PurchasesApi {
  //static const String googleKey = "goog_mbOazGtJOifblBAvWoAXkSkMmKs";
  static const String apiKey = 'goog_mbOazGtJOifblBAvWoAXkSkMmKs';

  // static Future init() async {
  //  // await Purchases.setDebugLogsEnabled(kDebugMode);
  //   // await Purchases.setup(apiKey, appUserId: user.id);
  //   PurchasesConfiguration purchasesConfiguration =
  //       PurchasesConfiguration(apiKey);
  //
  //   await Purchases.configure(purchasesConfiguration
  //     ..appUserID = FirebaseAuth.instance.currentUser!.uid);
  //   final result =
  //       await Purchases.logIn(FirebaseAuth.instance.currentUser!.uid);
  //   print(
  //       'intiliazed--=-${result.customerInfo.activeSubscriptions}-=-==-=0-=0-=oo-=o-=o=0k0=--=  ${FirebaseAuth.instance.currentUser!.uid}');
  // }
  //
  // static void logout() async {
  //   try {
  //     await Purchases.logOut();
  //   } on PlatformException catch (e) {
  //     CustomSnackBar.showCustomErrorToast(message: "${e.message}");
  //   }
  // }

  // static Future cancelSubscription(BuildContext context) async {
  //   String? url;
  //   try {
  //     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //
  //     url = customerInfo.managementURL;
  //     if (url == null) {
  //       Get.back();
  //       Fluttertoast.showToast(
  //         msg: 'You have no active subscriptions',
  //         backgroundColor: Colors.redAccent,
  //         textColor: Colors.white,
  //       );
  //     } else {
  //       if (!await launchUrl(Uri.parse(url))) {
  //         throw 'Could not launch $url';
  //       }
  //     }
  //   } on PlatformException catch (error) {
  //     Fluttertoast.showToast(
  //       msg: error.message!,
  //       backgroundColor: Colors.redAccent,
  //       textColor: Colors.white,
  //     );
  //   }
  // }
  //
  // static Future<List<Offering>> fetchOffers() async {
  //   try {
  //     final offerings = await Purchases.getOfferings();
  //     final current = offerings.current;
  //     Get.find<ChoosePlanController>().availablePackages =
  //         current != null ? current.availablePackages : [];
  //     if (kDebugMode) {
  //       print('purchase error: ------------- ${current!.availablePackages}');
  //     }
  //     return current == null ? [] : [current];
  //   } on PlatformException catch (e) {
  //     if (kDebugMode) {
  //       print('purchase error: ------------- $e');
  //     }
  //     return [];
  //   }
  // }
  //
  // static Future checkValidityOfPackage() async {
  //   MyAppUser myAppUser = MyAppUser.find;
  //   try {
  //     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //
  //     if (customerInfo.entitlements.all['Solo Plan']!.expirationDate ==
  //         myAppUser.subscriptionExpiryMilliseconds) {
  //       MyAppUser.find.isSubscriptionExpired = true;
  //       MyAppUser.find.subscriptionExpiryMilliseconds = null;
  //       MyAppUser.find.update(myAppUser);
  //
  //       await FirebaseFirestoreService.find
  //           .updateSubscriptionStatus(days: null, isExpired: true);
  //     }
  //   } on PlatformException catch (error) {
  //     Fluttertoast.showToast(
  //       msg: error.message!,
  //       backgroundColor: Colors.redAccent,
  //       textColor: Colors.white,
  //     );
  //   }
  // }

  // static Future<bool> purchasePackage(
  //     Package package, DateTime endDate, DateTime startDate) async {
  //   bool isPurchased = false;
  //
  //   try {
  //     CustomerInfo customerInfo = await Purchases.purchasePackage(package);
  //     appData.entitlementIsActive =
  //         customerInfo.entitlements.all['Solo Plan']!.isActive;
  //     isPurchased = appData.entitlementIsActive;
  //     await FirebaseFirestoreService.find.updateSubscriptionStatus(
  //         days: customerInfo.entitlements.all['Solo Plan']!.expirationDate);
  //     return isPurchased;
  //   } on PlatformException catch (e) {
  //     var errorCode = PurchasesErrorHelper.getErrorCode(e);
  //     if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
  //       Fluttertoast.showToast(
  //         msg: e.message!,
  //         backgroundColor: Colors.redAccent,
  //         textColor: Colors.white,
  //       );
  //     }
  //   }
  //
  //   isPurchased = appData.entitlementIsActive;
  //   Get.back();
  //   return isPurchased;
  // }
}

class AppData {
  static final AppData _appData = AppData._internal();

  bool entitlementIsActive = false;
  String appUserID = '';

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
