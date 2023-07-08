import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/components/custom_snackbar.dart';
import 'package:getx_skeleton/app/data/local/dynamic_link_payload_model.dart';
import 'package:getx_skeleton/app/data/local/invited_contact.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';
import 'package:getx_skeleton/app/services/country_services.dart';
import 'package:getx_skeleton/utils/DateFormate_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../utils/firebasepaths.dart';
import '../../../base_controller.dart';
import '../../../components/camera_image_picker_view.dart';
import '../../../controllers/my_app_user.dart';
import '../../../data/local/country_model.dart';
import '../../../services/FirebaseFirestoreServices.dart';
import '../../../services/firebase_storage_services.dart';
import '../../nav_profile/controller/profile_controller.dart';
import 'auth_controller.dart';

class SignUpController extends GetxController {
  File? profile;
  File? idFrontImage;
  File? idBackImage;
  static ProfileController get to => Get.find();
  final FirebaseFirestoreService firebaseFirestoreServices = Get.find();
  final FirebaseStorageService firebaseStorageService = Get.find();

  ImageSource source=ImageSource.gallery;

  photosPicked() {
    if (profile == null) {
      CustomSnackBar.showCustomErrorToast(message: "Pick Profile Image");
      return;
    } else if (idFrontImage == null) {
      CustomSnackBar.showCustomErrorToast(message: "Pick Id Front Image");
      return;
    } else if (idBackImage == null) {
      CustomSnackBar.showCustomErrorToast(message: "Pick Id Back Image");
      return;
    } else {
      Get.back();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCountries();
  }

  fetchCountries() async {
    List<LocalCountryModel> _countries =
        await CountryServices.find.getCountries();
    countries = _countries;
    update();
  }

  List<LocalCountryModel> countries = [];
  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  final TextEditingController guadrianId = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController dobC = TextEditingController();
  final TextEditingController firstlastNameC = TextEditingController();
  final TextEditingController countryC =
      TextEditingController(); // for UI only, actual value is [selectedCountryCode]
  String selectedCountryCode = 'US';
  final TextEditingController passwordC = TextEditingController();

  final TextEditingController confirmPasswordC = TextEditingController();
  final TextEditingController referralCodeC = TextEditingController();
  bool _isObsecure = true;

  validate(
      {DynamicLinkPayloadModel? payload,
      InvitedContactModel? invitedContactModel}) async {
    //Focus.of(Get.context!).unfocus();
    if (true) {
      // if (true ?? formKey.currentState?.validate() ?? false) {
      final myAppUser = MyAppUser();
      myAppUser.name = firstlastNameC.text.trim();
      myAppUser.email = emailC.text.trim();
      myAppUser.phonenumber = phoneC.text.trim();
      myAppUser.username = usernameC.text.trim();
      myAppUser.countryCode = selectedCountryCode.toLowerCase();
      myAppUser.dob = CustomeDateFormate.MillisecondsToDOB(dobC.text)
          .millisecondsSinceEpoch;
      if (profile == null) {
        CustomSnackBar.showCustomErrorToast(message: "Pick Profile Image");
        return;
      } else if (myAppUser.email == null) {
        CustomSnackBar.showCustomErrorToast(message: "Enter valid email");
        return;
      } else if (passwordC.text.trim() == "") {
        CustomSnackBar.showCustomErrorToast(message: "Enter valid password");
        return;
      } else if (myAppUser.phonenumber == null) {
        CustomSnackBar.showCustomErrorToast(
            message: "Enter valid phone number");
        return;
      } else if (myAppUser.username == null) {
        CustomSnackBar.showCustomErrorToast(message: "Enter valid username");
        return;
      } else if (myAppUser.dob == null) {
        CustomSnackBar.showCustomErrorToast(message: "Enter valid dob");
        return;
      } else if (myAppUser.name == null) {
        CustomSnackBar.showCustomErrorToast(message: "Enter valid name");
        return;
      } else if (passwordC.text.trim() != confirmPasswordC.text.trim()) {
        CustomSnackBar.showCustomErrorToast(message: "Password does not match");
        return;
      } else if (countryC.text.trim() == "") {
        CustomSnackBar.showCustomErrorToast(message: "Select country");
        return;
      }
      Logger().i(myAppUser.toMap());

      AuthState authState = await authController
          .signUpWithEmailPassword(myAppUser, passwordC.text, payload: payload);
      if (authState == AuthState.REGISTRATIONSUCESS) {
        authController.clearErrorMessage();

      /// uploading profile image
        String profileImage = await firebaseStorageService.uploadAFileToStorage(
            profile!, StoragePath.userImages(myAppUser.id!, profile!.path));
        await firebaseFirestoreServices.updateProfilePicture(url: profileImage);
        myAppUser.profileurl = profileImage;
        FirebaseAuth.instance.currentUser!.updatePhotoURL(myAppUser.profileurl);
        myAppUser.update(myAppUser);
        CustomSnackBar.showCustomSnackBar(
            title: "Profile updated",
            message: "Your Profile photo has been updated.");

     /// isInvited or signingUp on Own.
        if(invitedContactModel != null) {
          FirebaseFirestoreService.find.invitedByEntry(invitedContactModel);
        }

        /// uploading ID images.
        String front = await firebaseStorageService.uploadAFileToStorage(
            idFrontImage!, StoragePath.userIdImages(myAppUser.id!, idFrontImage!.path));
        String back = await firebaseStorageService.uploadAFileToStorage(
            idBackImage!, StoragePath.userIdImages(myAppUser.id!, idBackImage!.path));
        await FirebaseFirestore.instance.collection('userIdImages').doc().set({
          'uid':myAppUser.id,
          'idBackside':back,
          'idFrontSide':front,
        });

        authController.setState(ViewState.Idle);

        Get.offAllNamed(Routes.HOME);
      } else {
        print(authState);
      }
    } else {
      print("not validated");
    }
  }
  // Function to clear the cache
  Future<void> clearCache() async {
   await DefaultCacheManager().emptyCache();
  }

  //Getter setters below exists...
  bool get isObsecure => _isObsecure;

  set isObsecure(bool value) {
    _isObsecure = value;
    update();
  }

  cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    return File(croppedFile!.path);
  }


  showImagePickerBS(context,) async{
    await showModalBottomSheet(
      context: context,
      elevation: 10.0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      builder: (context) => CameraImagePickerView(
        pickFromCamera: () {
         source = ImageSource.camera;
         Navigator.pop(context);
        },
        pickFromGallery: () {
          source = ImageSource.gallery;
          Navigator.pop(context);
        },
      ),
    );
  }

  pickFrontImage(BuildContext context) async {


    final pickedFile = await ImagePicker.platform.pickImage(source: source);
    if (pickedFile != null) {
      idFrontImage = File(pickedFile.path);
      idFrontImage = await cropImage(idFrontImage!);
      update();
    }
  }

  pickProfileImage(BuildContext context) async {

    final pickedFile = await ImagePicker.platform.pickImage(source: source);
    if (pickedFile != null) {
      profile = File(pickedFile.path);
      profile = await cropImage(profile!);
      update();
    }
  }

  pickBackImage(BuildContext context) async {

    final pickedFile = await ImagePicker.platform.pickImage(source: source);
    if (pickedFile != null) {
      idBackImage = File(pickedFile.path);
      idBackImage = await cropImage(idBackImage!);
      update();
    }
  }
}
