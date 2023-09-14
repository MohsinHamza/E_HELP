import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/modules/auth/controller/auth_controller.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';

import '../../controllers/my_app_user.dart';
import '../auth/sign_in_screen.dart';

class SplashScreen extends GetView<AuthController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<MyAppUser?>(
          stream: controller.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return Center(
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(

                    image: DecorationImage(image: AssetImage("assets/icons/men_logo.png"), fit: BoxFit.fitHeight),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const LoginScreen();
            }
            final user = snapshot.data;
            return FutureBuilder<MyAppUser>(
              future: FirebaseFirestoreService.find.loadMyAppUserData(user?.id ?? ""),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Container(
                    height: 100,

                    decoration: const BoxDecoration(

                      image: DecorationImage(image: AssetImage("assets/icons/men_logo.png"), fit: BoxFit.fitHeight),
                    ),
                  ));
                } else {
                  MyAppUser? user = snapshot.data;

                  if (user != null) {
                    MyAppUser.find.update(user);
                    debugPrint('user: ' + user.toString());
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Get.offAndToNamed(Routes.HOME);
                    });
                    return Center(
                      child: Container(
                        height: 100,

                        decoration: const BoxDecoration(

                          image: DecorationImage(image: AssetImage("assets/icons/men_logo.png"), fit: BoxFit.fitHeight),
                        ),
                      ),
                    );
                  } else {
                    return const LoginScreen();
                  }
                }
              },
            );
          }),
    );
  }
}
