import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/CacheNetworkWidget.dart';
import 'package:getx_skeleton/app/controllers/choose_plan_controller.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';
import 'package:getx_skeleton/utils/debounder_helper.dart';
import 'app/components/reuseable_button.dart';
import 'app/controllers/app_config_controller.dart';
import 'app/controllers/groups_controller.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/modules/home/views/family_pages/controllers.dart';
import 'app/modules/nav_emergency/evidence_permission.dart';
import 'app/modules/nav_emergency/record_evidence.dart';
import 'app/modules/nav_profile/controller/profile_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/FirebaseFirestoreServices.dart';
import 'app/services/auth_firebase_services.dart';
import 'app/services/country_services.dart';
import 'app/services/dynamic_link_services.dart';
import 'app/services/firebase_storage_services.dart';
import 'app/services/location_services.dart';
import 'app/services/logger_services.dart';
import 'config/theme/my_theme.dart';
import 'utils/fcm_helper.dart';

///DependencyInjection

void di() {
  Get.lazyPut(() => MyAppUser());
  Get.lazyPut(() => AppConfigController(), fenix: true);

  // Get.lazyPut<TransactionAlertController>(() => TransactionAlertController());
  Get.lazyPut<EvidencePermissionController>(
    () => EvidencePermissionController(),
  );
  Get.lazyPut<ProfileController>(
    () => ProfileController(),
  );
  Get.lazyPut(() => FirebaseFirestoreService());
  Get.lazyPut(() => RecordEvidenceController());
  Get.lazyPut(() => LocationServices());
  Get.lazyPut(() => FirebaseStorageService());
  Get.lazyPut(() => FirebaseAuthService());
  Get.lazyPut(() => Debouncer());
  Get.lazyPut(() => LoggerServices());
  Get.lazyPut(() => CountryServices());
  Get.lazyPut(() => ChoosePlanController());
  Get.lazyPut(() => GlobalGroupsController());
  //Get.lazyPut(()=>GroupsController());
  Get.lazyPut<EvidencePermissionController>(
    () => EvidencePermissionController(),
  );
}

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await MySharedPref.init();

  // dependency injection...
  di();

  // inti fcm & notifications services (awesome notifications)
  await FcmHelper.initFcm();

  //init Stripe Config
  //Stripe.publishableKey = stripePublishableKey;

  //app starts here...
  // FirebaseAuthService().signOut();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, widget) {
          return const MyApp();
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Future.microtask(() async {
      await DynamicLinkServices().initDynamicLinks(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "EHelp App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      builder: (context, widget) {
        bool themeIsLight = MySharedPref.getThemeIsLight();
        return Theme(
          data: MyTheme.getThemeData(isLight: themeIsLight,context: context),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          ),
        );
      },

      home: const WrapperWidget(),
      initialRoute: AppPages.INITIAL,
      // first screen to show when app is running
      getPages: AppPages.routes, // app screens
    );
  }
}

class WrapperWidget extends StatefulWidget {
  const WrapperWidget({Key? key}) : super(key: key);

  @override
  State<WrapperWidget> createState() => _WrapperWidgetState();
}

class _WrapperWidgetState extends State<WrapperWidget> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<MyAppUser?>(
        stream: Get.find<FirebaseAuthService>().authStateChanges,
        builder: (BuildContext context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/icons/men_logo.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            );
          }

          if (snap.data != null) {
            //PurchasesApi.init();
            return FutureBuilder<MyAppUser?>(
                future: FirebaseFirestoreService.find
                    .loadMyAppUserData(snap.data?.id ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/icons/men_logo.png"),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                    );
                  }

                  MyAppUser.find.update(snapshot.data!);

                  ///todo: berta da ham enable ka
                  // if (snapshot.data?.isSubscriptionExpired == true ||
                  //     snapshot.data?.isSubscriptionExpired == null) {
                  //   if (kDebugMode) {
                  //     print(
                  //         "IS EXPIRED ${snapshot.data?.isSubscriptionExpired}");
                  //   }
                  //   Future.delayed(200.milliseconds).then(
                  //     (value) async {
                  //       return Get.offAll(
                  //         SubscriptionExpiredScreen(user: snap.data),
                  //       );
                  //     },
                  //   );

                  //   return Center(
                  //     child: Container(
                  //       height: 140,
                  //       width: 140,
                  //       decoration: const BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         image: DecorationImage(
                  //           image: AssetImage(
                  //             "assets/icons/men_logo.png",
                  //           ),
                  //           fit: BoxFit.fitHeight,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }

                  // Future.delayed(200.milliseconds).then(
                  //   (value) async {
                  //     return Get.offAllNamed(Routes.HOME);
                  //   },
                  // );
                  return Center(
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/icons/men_logo.png"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  );
                });

            // MyAppUser.find.update(snap.data!);
            // Get.find<FirebaseAuthService>().isSubscriptionExpired(snap.data?.subscriptionExpiryMilliseconds).then((value) => {
            //       if (value == true || value == null)
            //         {
            //           Get.offAll(SubscriptionExpiredScreen(
            //             user: snap.data,
            //           )),
            //         }
            //     });
          }
          return Center(
            child: Container(
              height: 140,
              width: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/icons/men_logo.png",
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubscriptionExpiredScreen extends StatelessWidget {
  MyAppUser? user;

  SubscriptionExpiredScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    user = user ?? MyAppUser.find;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Subscription Expired"),
      ),
      body: Center(
        child: FutureBuilder<MyAppUser?>(
            future:
                FirebaseFirestoreService.find.loadMyAppUserData(user?.id ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator.adaptive();
              }
              MyAppUser.find.update(snapshot.data!);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CacheNetworkWidget(
                          height: 200,
                          imageUrl: MyAppUser.find.profileurl ?? ""),
                    ),
                  ),
                  // CircleAvatar(radius: 42, backgroundImage: CachedNetworkImageProvider(MyAppUser.find.profileurl ?? "")),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "${snapshot.data?.name ?? "you"} no subscriptions! Please buy new subscription in "
                      "order to use E Help App",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Reuseable_button(
                      "Buy Subscription",
                      AppColors.lightRed,
                      SvgPicture.asset(""),
                      () {
                        // Get.offAll(
                        //   const Choose_Your_Plans(),
                        // );
                      },
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Get.find<AuthService>().signOut();
                      //PurchasesApi.logout();
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightRed,
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
