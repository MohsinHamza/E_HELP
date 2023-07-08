import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/app/data/local/dynamic_link_payload_model.dart';
import 'package:getx_skeleton/app/data/local/invited_contact.dart';
import 'package:getx_skeleton/app/routes/app_pages.dart';
import 'package:getx_skeleton/app/services/logger_services.dart';

import '../../config/.env.dart';
import 'auth_firebase_services.dart';

abstract class DynamicLinkAbs {
  Future<bool> initDynamicLinks(BuildContext context);

  Future<String?> createDynamicLink(String link, {bool short = false});

  generateUrlParamsDonation(
      {required String phoneNumber,
      required String guardianName,
      required double guardianUid,
      required double durationStart,
      required double durationEnd});
}

class DynamicLinkServices implements DynamicLinkAbs {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;


  @override
  Future<bool> initDynamicLinks(BuildContext context) async {
    LoggerServices.find.log("*************initDynamicLinks*****************");

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data,context);


    FirebaseDynamicLinks.instance.onLink.listen((event) {
      final Uri uri = event.link;

      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty ) {
        LoggerServices.find
            .log("$queryParams <= query params onLink");
        try {
          if (queryParams["invitedBy"] != null) {
            final InvitedContactModel model0 =
                InvitedContactModel.fromMap(queryParams);
            Get.find<FirebaseAuthService>().signOut();
            Get.offAllNamed(Routes.getRouteSignup(invitedContactModel: model0));

          } else {
            final DynamicLinkPayloadModel? model;
            model = DynamicLinkPayloadModel.fromMap(queryParams);
            Get.find<FirebaseAuthService>().signOut();
            Get.offAllNamed(Routes.getRouteSignup(model: model));

          }
        } catch (e) {
          debugPrint(e.toString());

        }
      } else {
        LoggerServices.find.logD("$queryParams <= else case for queryParams?.isNotEmpty ?? false");

      }
    });
   return true;
  }

  @override
  Future<String?> createDynamicLink(String link,
      {bool short = false, bool isInvitedContact = false}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: dynamicLinkDomain,
      link: Uri.parse(isInvitedContact
          ? dynamicLinkInvitedByPath + link
          : dynamicLinkPath + link),
      androidParameters: const AndroidParameters(
          packageName: appBundleAppId, minimumVersion: minAndroidVersion),
      iosParameters: const IOSParameters(
          bundleId: appBundleAppId, minimumVersion: minIosVersion),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }

    LoggerServices.find.logD("Generated Link: ${url.toString()}");
    return url.toString();
  }

  @override
  String generateUrlParamsDonation(
      {required String phoneNumber,
      required String guardianName,
      required double guardianUid,
      required double durationStart,
      required double durationEnd}) {
    return "?phoneNumber=$phoneNumber&guardianName=$guardianName&guardianUid=$guardianUid&durationStart=$durationStart"
        "&durationEnd=$durationEnd";
  }

  void _handleDynamicLink(PendingDynamicLinkData? data,BuildContext context) async{
    try {
      final Uri? uri = data?.link;

      final queryParams = uri?.queryParameters;
      debugPrint(queryParams.toString());
      if (queryParams?.isNotEmpty ?? false) {
        LoggerServices.find
            .log("$queryParams <= query params getInitialLink ");
        final DynamicLinkPayloadModel? model;
        model = DynamicLinkPayloadModel.fromMap(queryParams);

        //await Get.offAllNamed(Routes.getRouteSignup(model: model));
        await Navigator.pushReplacementNamed(context, Routes.getRouteSignup(model: model));

      }

    } on dynamic catch (e) {
      LoggerServices.find.logError(e.message);
      LoggerServices.find.logError(e.details);

    } catch (e) {
      LoggerServices.find.logError("No deep link found");

    }
  }
}
