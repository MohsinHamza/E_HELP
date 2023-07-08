import 'dart:io';

import 'package:fast_contacts/fast_contacts.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/controllers/my_app_user.dart';
import 'package:getx_skeleton/app/data/local/invited_contact.dart';
import 'package:getx_skeleton/utils/functions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/dynamic_link_services.dart';

class InviteController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getMyContactList();
  }

  RxBool isLoading = false.obs;
  final DynamicLinkServices _dynamicLinkServices = DynamicLinkServices();
  final MyAppUser _myAppUser = MyAppUser.find;
  final _contacts = <Contact>[].obs;

  ///* Call when press on [invite] from UI
  onInvitePress({required Contact contact}) async {
    final String? phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : null;
    if (phoneNumber == null) {
      CustomSnackBar.showCustomErrorToast(message: "No phone number found for this contact");
      return;
    }
    String? url = await _generateInviteLink(phoneNumber: phoneNumber);
    if (url != null) {
      String message = "Hey, I'm using Medical Emergency App. It covers all my emergency needs just by tapping emergency button. Use my "
          "referral "
          "code: "
          "${_myAppUser.id} to get \$5 off on your first subscription."
        " Use this link to download: $url"
      ;
      Functions.sendMessage(phoneNumber, message);
    } else {
      CustomSnackBar.showCustomErrorToast(message: "Something went wrong, Try again later");
    }
  }

  Future<String?> _generateInviteLink({required String phoneNumber}) async {
    final InvitedContactModel _model = InvitedContactModel(invitedBy: _myAppUser.id.toString(), expiryMillis: DateTime.now().add(90.days).millisecondsSinceEpoch.toString());
    return await _dynamicLinkServices.createDynamicLink(_model.toString(), short: true, isInvitedContact: true);
  }

  ///Fetches contact list from the device
  getMyContactList() async {
    isLoading.value = true;

    contacts = await InviteServices().getContactList();
    isLoading.value = false;
  }

  List<Contact> get contacts => _contacts.value;

  set contacts(List<Contact> value) {
    _contacts.value = value;
  }
}

class InviteBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteController>(() => InviteController());
  }
}

class InviteServices extends GetxService {
  static InviteServices find = Get.find();

  Future<bool> contactPermissionsGranted() async {
    PermissionStatus? contactsPermissionsStatus = await _contactsPermissions();
    if (contactsPermissionsStatus == PermissionStatus.granted) {
      print("Contacts permission granted");
      return true;
    } else {
      print("Contacts permission not granted ${contactsPermissionsStatus.toString()}");

      return false;
    }
  }

  Future<PermissionStatus?> _contactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus = await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }

  Future<List<Contact>> getContactList() async {
    List<Contact> contacts = [];
    try {
      if (Platform.isAndroid) {
        bool isGranted = await contactPermissionsGranted();
        if (isGranted) {
          contacts = await FastContacts.getAllContacts();
        }
      } else {
        contacts = await FastContacts.getAllContacts();
      }
    } catch (E) {
      print(E);
      CustomSnackBar.showCustomSnackBar(title: "err", message: E.toString());
    }
    return contacts;
  }
}
