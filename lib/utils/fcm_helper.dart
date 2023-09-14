import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getx_skeleton/app/services/logger_services.dart';
import 'package:getx_skeleton/config/theme/custom_app_colors.dart';
import 'package:logger/logger.dart';

import '../app/data/local/my_shared_pref.dart';
import 'firebasepaths.dart';

class FcmHelper {
  // FCM Messaging
  static late FirebaseMessaging messaging;

  // Notification lib
  static AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize fcm and firebase core
      await Firebase.initializeApp(
          //  only un comment this line if you set up firebase vie firebase cli
          //options: DefaultFirebaseOptions.currentPlatform,
          );
      messaging = FirebaseMessaging.instance;

      // initialize notifications channel and libraries
      await _initNotification();

      // notification settings handler
      await _setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await _generateFcmToken();

      awesomeNotifications.requestPermissionToSendNotifications(channelKey: NotificationChannels.generalChannelKey, permissions: [
        NotificationPermission.Alert,
        NotificationPermission.Sound,
        NotificationPermission.Badge,
        NotificationPermission.Vibration,
        NotificationPermission.Light,
        // NotificationPermission.CriticalAlert,
        NotificationPermission.FullScreenIntent,
        // NotificationPermission.OverrideDnD,
      ]);

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

      // listen to notifications clicks
      listenToActionButtons();
    } catch (error) {
      print(error);
    }
  }

  // when user click on notification or click on button on the notification
  static listenToActionButtons() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedNotification receivedNotification) async {
        debugPrint(receivedNotification.toMap().toString());
      },
    );
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> _setupFcmNotificationSettings() async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(alert: true, sound: true, badge: true);

    //NotificationSettings settings
    await messaging.requestPermission(alert: true, badge: true, sound: true, provisional: true, criticalAlert: true);
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> _generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      if (token != null) {
        MySharedPref.setFcmToken(token);
        print(token.toString());
        _sendFcmTokenToServer(token);
      } else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        _generateFcmToken();
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  /// this method will be triggered when the app generate fcm
  /// token successfully
  static _sendFcmTokenToServer(String token) async {
    LoggerServices.find.logD("TOKEN SENDING TO SERVER");
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      await FirebasePath.users(FirebaseAuth.instance.currentUser?.uid ?? "").set({
        "token": token,
      }, SetOptions(merge: true));
    }
  }

  ///handle fcm notification when app is closed/terminated
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    print(message.toMap());
    _showNotification(id: 1, title: message.notification?.title ?? 'Title', body: message.notification?.body ?? 'Body', payload: message.data['payload']);
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    print(message.toMap());
    _showNotification(id: 1, title: message.data["title"] ?? message.notification?.title ?? "", body: message.data["body"] ?? message.notification?.body ?? "", payload: message.data['payload']);
  }

  //display notification for user with sound
  static _showNotification({required String title, required String body, required int id, String? channelKey, NotificationLayout? notificationLayout, String? summary, Map<String, String>? payload, String? largeIcon}) async {
    awesomeNotifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        awesomeNotifications.requestPermissionToSendNotifications(channelKey: NotificationChannels.generalChannelKey, permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          NotificationPermission.CriticalAlert,
          NotificationPermission.FullScreenIntent,
          NotificationPermission.OverrideDnD,
        ]);
      } else {
        // u can show notification
        awesomeNotifications.createNotification(
            content: NotificationContent(
                id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                title: title,
                criticalAlert: true,
                color: Colors.red,
                displayOnBackground: true,
                displayOnForeground: true,
                backgroundColor: Colors.red,
                locked: true,
                wakeUpScreen: true,
                body: body,
                fullScreenIntent: true,
                channelKey: channelKey ?? NotificationChannels.generalChannelKey,
                bigPicture: "asset://assets/images/Medical Emergency Network-LOGO-A3.jpg",
                showWhen: true,
                // Hide/show the time elapsed since notification was displayed
                payload: payload,
                // data of the notification (it will be used when user clicks on notification)
                notificationLayout: NotificationLayout.BigText,
                // notification shape (message,media player..etc) For ex => NotificationLayout.Messaging
                autoDismissible: false,
                // dismiss notification when user clicks on it
                summary: summary,
                // for ex: New message (it will be shown on status bar before notificaiton shows up)
                largeIcon: largeIcon // image of sender for ex (when someone send you message his image will be shown)
                ));
      }
    });
  }

  ///init notifications channels
  static _initNotification() async {
    await awesomeNotifications.initialize(
        null, // null mean it will show app icon on the notification (status bar)
        [
          NotificationChannel(
              enableLights: true,
              enableVibration: true,
              channelKey: NotificationChannels.generalChannelKey,
              channelName: NotificationChannels.generalChannelName,
              channelDescription: 'Notification channel for general notifications',
              defaultColor: AppColors.lightRed,
              ledColor: Colors.red,
              channelShowBadge: true,
              playSound: true,
              criticalAlerts: true,
              importance: NotificationImportance.Max)
        ]);
  }
}

class NotificationChannels {
  // chat channel (for messages only)
  static String get chatChannelKey => "men";

  static String get chatChannelName => "men";

  static String get chatChannelDescription => "men";

  // general channel (for all other notifications)
  static String get generalChannelKey => "men";

  static String get generalChannelName => "men";

  static String get generalChannelDescription => "men";
}
