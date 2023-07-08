import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';
import '../../../../config/theme/custom_app_colors.dart';
import '../../../components/rounded_button.dart';
import '../controllers/home_controller.dart';

///Includes BottomNavBar...
class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // todo: subscription needs to be controlled from here

    // if (Get.find<MyAppUser>().isSubscriptionExpired == true) {
    //   Future.delayed(400.milliseconds).then(
    //         (value) => Get.offAll(
    //       SubscriptionExpiredScreen(
    //         user: Get.find<MyAppUser>(),
    //       ),
    //     ),
    //   );
    // } else if (Get.find<MyAppUser>().isSubscriptionExpired == null) {
    //   SchedulerBinding.instance.addPostFrameCallback(
    //         (timeStamp) {
    //       Get.offAll(
    //         const Choose_Your_Plans(),
    //       );
    //     },
    //   );
    // }

    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: Routes.LOCATE,
        onGenerateRoute: AppPages.onGenerateNavBarRoute,
      ),
      floatingActionButton: const RoundedButton(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          selectedItemColor: AppColors.Kblue_type,
          unselectedItemColor: Colors.grey,
          onTap: controller.changePage,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon:Image.asset('assets/svg_icons/booking.png'),
                label: 'Booking'),

            const BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                label: 'Contacts'),

            // const BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle_sharp, color: Colors.black), label: 'Users'),
            // BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, color: Colors.black), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
