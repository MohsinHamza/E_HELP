import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/local/invited_contact.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/modules/home/views/booking_view.dart';
import 'package:getx_skeleton/app/modules/home/views/family_pages/create_group.dart';
import 'package:getx_skeleton/app/modules/home/views/home_view.dart';
import 'package:getx_skeleton/app/modules/nav_contacts/Emergency_contacts.dart';
import 'package:getx_skeleton/app/modules/nav_emergency/transaction_alert.dart';
import 'package:getx_skeleton/app/modules/nav_locate/controller/location_controller.dart';
import 'package:getx_skeleton/app/modules/nav_profile/id_photos_page.dart';
import 'package:getx_skeleton/app/modules/nav_profile/profile_page.dart';
import 'package:getx_skeleton/app/modules/splash/splash_screen.dart';
import 'package:getx_skeleton/app/services/decode_encode_services.dart';
import '../data/local/dynamic_link_payload_model.dart';
import '../modules/add_emergency_contacts/add_emergency_contacts.dart';
import '../modules/add_emergency_contacts/controller/add_emergency_contacts_controller.dart';
import '../modules/auth/controller/auth_controller.dart';
import '../modules/auth/sign_in_screen.dart';
import '../modules/auth/sign_up_screen.dart';
import '../modules/feeback_screen/feedback_Screen.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/home/views/family_pages/add_new_group_member.dart';
import '../modules/home/views/family_pages/emergency_family_groups.dart';
import '../modules/home/views/family_pages/emergency_group_map_page.dart';
import '../modules/invite_friends/controllers/invite_controller.dart';
import '../modules/invite_friends/invite_friends_view.dart';
import '../modules/nav_contacts/controller/emergency_contacts_controller.dart';
import '../modules/nav_contacts/controller/pay_for_friend_family_controller.dart';
import '../modules/nav_emergency/controllers/transaction_alert_controller.dart';
import '../modules/nav_emergency/evidence_permission.dart';
import '../modules/nav_emergency/my_evidence.dart';
import '../modules/nav_emergency/record_evidence.dart';
import '../modules/nav_profile/components/how_to_use_app.dart';
import '../modules/nav_users/pay_for_friendorfamily.dart';
import '../modules/nav_locate/location_premission.dart';
import '../modules/nav_profile/controller/profile_controller.dart';
import '../modules/nav_users/Paid_Contacts.dart';
import '../modules/nav_users/controllers/users_controllers.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: Routes.EMERGENCYTYPE,
        page: () {
          return EmergencyPermission();
        },
        binding: EvidencePermissionControllerBinding()),
    GetPage(
      name: Routes.RECORDEVIDENCE,
      page: () {
        return RecordEvidence();
      },
      binding: RecordEvidenceControllerBinding(),
    ),
    GetPage(
      name: Routes.MYEVIDENCES,
      page: () {
        return MyEvidences();
      },
      binding: MyEvidencesControllerBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () {
        return const Profile_Page();
      },
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.HOW_TO_USE_APP,
      page: () {
        return const HowToUseTheApp();
      },
    ),
    GetPage(
      name: Routes.INVITE,
      page: () {
        return const InviteScreen();
      },
      binding: InviteBindings(),
    ),
    GetPage(
      name: Routes.CONTACTS,
      page: () {
        return const EmergencyContacts();
      },
      binding: ContactsBinding(),
    ),
    GetPage(
      name: Routes.FEEDBACK,
      page: () {
        return const FeedbackView();
      },
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: AuthBindings(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBindings(),
    ),

    // GetPage(
    //     transition: Transition.fadeIn,
    //     name: Routes.PLANS,
    //     page: () => const Choose_Your_Plans(),
    //     binding: Choose_Your_PlansBindings()),

    GetPage(
      transition: Transition.fadeIn,
      name: Routes.EMERGENCY_FAMILY_GROUPS_MAP,
      page: () => const FamilyEmergencyMapPage(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: Routes.CREATEGROUP,
      page: () => const CreateGroup(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: Routes.ADDGROUPMEMBER,
      page: () => const AddGroupMember(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: Routes.EMERGENCY_FAMILY_GROUPS,
      page: () => const FamilyEmergencyGroupsPage(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: Routes.SIGNUP,
      page: () {
        String? _data = Get.parameters['data']?.toString();
        print(_data);
        if (_data == 'null' || _data == null) {
          print("TRUE ITS NULL from Signuop Page");
          return const SignupScreen(dynamicLinkPayloadModel: null);
        }
        DynamicLinkPayloadModel? model;
        InvitedContactModel? invitedContactModel;
        Map _dataBody = decodeArgument(_data);
        if (_dataBody["invitedBy"] != null) {
          invitedContactModel = InvitedContactModel.fromMap(_dataBody);
        } else {
          model = DynamicLinkPayloadModel.fromMap(_dataBody);
        }

        return SignupScreen(
          dynamicLinkPayloadModel: model,
          invitedContactModel: invitedContactModel,
        );
      },
      binding: AuthBindings(),
    ),
    GetPage(
      transition: Transition.circularReveal,
      name: Routes.SEEYOURID,
      page: () => const IDPhotosPage(),
    ),
    GetPage(
      transition: Transition.circularReveal,
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ADD_EMERGENCY_CONTACT,
      page: () {
        String? _data = Get.parameters['data'].toString();
        if (_data == 'null') {
          return const AddEmergencyContact();
        }
        ContactModel? model = ContactModel.fromMap(decodeArgument(_data));
        return AddEmergencyContact(contact: model);
      },
      binding: AddEmergencyContactsBinding(),
    ),
    GetPage(
      name: Routes.PAY_FOR_FAMILY_FRIEND,
      page: () => const PayForFriendFamilyScreen(),
      binding: PayForFriendFamilyBinding(),
    ),
    GetPage(
      name: Routes.LOCATE,
      page: () {
        debugPrint(
            "LOCASTE ${Get.parameters['isMonthlySelected'].toString().toLowerCase() == "true" ? true : false}");
        return LocationScreen(
          isFromExpired: Get.parameters['isFromExpired'] != null,
          isMonthlySelected:
              Get.parameters['isMonthlySelected'].toString().toLowerCase() ==
                      "true"
                  ? true
                  : false,
        );
      },
      binding: LocationBinding(),
    ),
    GetPage(
      name: Routes.BOOKINGS,
      page: () {
        debugPrint(
            "LOCASTE ${Get.parameters['isMonthlySelected'].toString().toLowerCase() == "true" ? true : false}");
        // return LocationScreen(
        //   isFromExpired: Get.parameters['isFromExpired'] != null,
        //   isMonthlySelected:
        //       Get.parameters['isMonthlySelected'].toString().toLowerCase() ==
        //               "true"
        //           ? true
        //           : false,
        // );
        return BookingScreen(
          isFromExpired: Get.parameters['isFromExpired'] != null,
          isMonthlySelected:
              Get.parameters['isMonthlySelected'].toString().toLowerCase() ==
                      "true"
                  ? true
                  : false,
        );
      },
    ),
  ];

  ///Use for navbar routing navigation with no transition ok....
  static Route? onGenerateNavBarRoute(RouteSettings settings) {
    if (settings.name == _Paths.LOCATE) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const LocationScreen(),
        binding: LocationBinding(),
      );
    }

    // if (settings.name == _Paths.PLANS) {
    //   return GetPageRoute(
    //       transition: Transition.noTransition,
    //       settings: settings,
    //       page: () => const Choose_Your_Plans(),
    //       binding: Choose_Your_PlansBindings());
    // }

    if (settings.name == _Paths.CONTACTS) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const EmergencyContacts(),
        binding: ContactsBinding(),
      );
    }

    if (settings.name == _Paths.EMERGENCY) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const SendAlertScreen(),
        binding: TransactionAlertBinding(),
      );
    }

    if (settings.name == _Paths.USERS) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const PaidContacts(),
        binding: UsersBinding(),
      );
    }
    if (settings.name == _Paths.PROFILE) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const Profile_Page(),
        binding: ProfileBinding(),
      );
    }
    if (settings.name == _Paths.EMERGENCY_FAMILY_GROUPS_MAP) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const FamilyEmergencyMapPage(),
      );
    }
    if (settings.name == _Paths.CREATEGROUP) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const CreateGroup(),
      );
    }
    if (settings.name == _Paths.ADDGROUPMEMBER) {
      return GetPageRoute(
        transition: Transition.rightToLeft,
        settings: settings,
        page: () => const AddGroupMember(),
      );
    }
    if (settings.name == _Paths.EMERGENCY_FAMILY_GROUPS) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const FamilyEmergencyGroupsPage(),
      );
    }
    if (settings.name == _Paths.FEEDBACK) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const FeedbackView(),
      );
    }
    if (settings.name == _Paths.SEEYOURID) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const IDPhotosPage(),
      );
    }
    if (settings.name == _Paths.EMERGENCYTYPE) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => EmergencyPermission(),
        binding: EvidencePermissionControllerBinding(),
      );
    }
    if (settings.name == _Paths.RECORDEVIDENCE) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => RecordEvidence(),
      );
    }
    if (settings.name == _Paths.BOOKINGS) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const BookingScreen(),
      );
    }
    if (settings.name == _Paths.INVITE) {
      return GetPageRoute(
        transition: Transition.noTransition,
        settings: settings,
        page: () => const InviteScreen(),
        binding: InviteBindings(),
      );
    }
    return null;
  }
}
