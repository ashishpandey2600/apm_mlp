import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificatrionService {
static  Future<void> initialise() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(); //only for ios
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("Notifications Initialized!");
    }
  }
}
