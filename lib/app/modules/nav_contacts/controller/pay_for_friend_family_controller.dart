import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/controllers/app_config_controller.dart';
import 'package:getx_skeleton/app/controllers/payment_controller.dart';
import 'package:getx_skeleton/app/data/local/price_model.dart';
import 'package:getx_skeleton/app/data/models/contact_model.dart';
import 'package:getx_skeleton/app/modules/nav_users/controllers/users_controllers.dart';
import 'package:getx_skeleton/app/services/FirebaseFirestoreServices.dart';
import 'package:getx_skeleton/app/services/logger_services.dart';

import '../../../controllers/my_app_user.dart';
import '../../../data/local/dynamic_link_payload_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/dynamic_link_services.dart';

class PayForFriendFamilyController extends GetxController {
  @override
  onReady() {
    super.onReady();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    stripeId = MyAppUser.find.stripeId ?? "";
    priceList = Get.find<AppConfigController>().priceList;
  }

  List<PriceModel> priceList = Get.find<AppConfigController>().priceList;
  late String stripeId;

  static PayForFriendFamilyController get find => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController phoneNumberC = TextEditingController();
  TextEditingController subscriptionC = TextEditingController();
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode subscriptionCFocus = FocusNode();
  PriceModel? _priceModel;

  PriceModel? get priceModel => _priceModel;

  set priceModel(PriceModel? value) {
    _priceModel = value;
    update();
  }

  final firebaseFirestoreService = FirebaseFirestoreService.find;
  final myUser = MyAppUser.find;

  void onClickRadioButton(value) {
    subscriptionC.text = value;
    priceModel = priceList.firstWhere((element) => element.priceName == value);
    update();
  }

  Future<void> submit() async {
    //TODO: IMP SHIFT THIS COMMENTED TO HOME SCREEN

    // SubscriptionPaymentController.create.initPaymentSchedule(
    //   customerId: stripeId,
    //   priceModel: priceModel,
    //   startDate: DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
    //   onPaymentSuccessCallBack:() {
    //
    //   });
    if (formKey.currentState?.validate() ?? false ) {
      formKey.currentState?.save();
      if(priceModel != null){
        await _initiatePayment();

      }
    }
  }

  _initiatePayment() async {
    ContactModel contact = ContactModel();
    contact.name = nameC.text;
    contact.phoneNumber = phoneNumberC.text;
    contact.isPaid = false;
    // SubscriptionPaymentController.create.processPayment(
    //     priceModel: priceModel,
    //     model: contact,
    //     onPaymentSuccessCallBack: () {
    //       _onPaymentSuccess(contact);
    //     });
    // TODO://TODO  //single payment below  commented///TODO:
      SinglePaymentController.create.processPayment(
        amount: _priceModel?.price.toString() ?? "120",
        contactModel: contact,
        toNumber: contact.phoneNumber,
        onPaymentSuccessCallBack: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          _onPaymentSuccess(contact);
          // Get.off( First_Chechkout(model: contact,));
          // Get.to(Payment_page(2));
        });
  }

  _onPaymentSuccess(ContactModel contact) async {
    _createDynamicLink(contact);
    Get.offAllNamed(Routes.HOME);
    var resp = await firebaseFirestoreService.addPaidContact(contact);
    if (resp != null) {
      updateLocally(contact);
      CustomSnackBar.showCustomToast(message: "You've added successfully new paid contact");
    } else {
      CustomSnackBar.showCustomErrorToast(message: "Something went wrong!. Please try again!");
    }
  }

  _createDynamicLink(ContactModel contact) async {
    DynamicLinkPayloadModel m = DynamicLinkPayloadModel(
        phoneNumber: contact.phoneNumber ?? "",
        guardianName: myUser.name ?? "",
        guardianUid: myUser.id ?? "",
        durationStart: DateTime.now().millisecondsSinceEpoch,
        durationEnd: DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch);
    LoggerServices.find.logD(contact.toString());
    String? url = await DynamicLinkServices().createDynamicLink(m.toString(), short: true);
    sendToPhone(contact.phoneNumber, url);
  }
///Send SMS to Phone Number with Link.
  sendToPhone(String? phoneNumber, String? url) async {
    if (phoneNumber != null && url != null) {
      firebaseFirestoreService.sendEmail(
          toNumber: phoneNumber,
          message: "${myUser.name} have bought a subscription for you on Medical "
              "Emergency Application. Create an account using this link only once and enjoy the benefits of our application. Link: $url");
    } else {
      CustomSnackBar.showCustomErrorToast(message: "Something went wrong!. Please contact with admin support");
    }
  }

  updateLocally(ContactModel? model) {
    Get.find<UsersController>().updateContactLocal(model, shouldAdd: true);
  }
}

class PayForFriendFamilyBinding extends Bindings {
  @override
  void dependencies() {
    print("PayForFriendFamilyBinding");
    print("PPaymentController Binding");
    Get.lazyPut<PayForFriendFamilyController>(
      () => PayForFriendFamilyController(),
    );
    Get.lazyPut<SinglePaymentController>(
      () => SinglePaymentController(),
    );
  }
}