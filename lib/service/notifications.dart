//Author: Ishan Parikh
//Purpose: implementation class for flutter push notifications

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifier {
  // Instance of Flutternotification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late InitializationSettings initSettings;

  init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // wait for set permissions
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (String? payload) async {
        //idk
      },
    );

    //configure timezone for android
    await _configureLocalTimeZone();
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  Future<void> showNextStep(String recipeName, String timestamp, int mass) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      "notif",
      'New Step',
      '...',
      importance: Importance.high,
      priority: Priority.max,
      timeoutAfter: 4000,
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0,
        'New Step: Add $mass grams by $timestamp',
        'New Step in your brew! Add to $mass grams by $timestamp',
        notificationDetails);
  }
}