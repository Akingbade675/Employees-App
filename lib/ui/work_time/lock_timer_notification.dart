import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LockScreenTimerNotification {

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // onSelectNotification: (payload) {
        //   setState(() {
        //     _elapsedTime = payload;
        //   });}
        );
  }
}