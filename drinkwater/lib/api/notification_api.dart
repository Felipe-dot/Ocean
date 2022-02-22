import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        // 'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
   }
  
  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {},
    );
  })


  static Future showScheduleNotification({
    int id = 0,
    String title,
    String body,
    String payload,
    DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        androidAllowWhileIdle: true,
        await _notificationDetails(
          
        ),
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
}
