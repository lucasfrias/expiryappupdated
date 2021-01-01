
import 'package:expiryapp/screen_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  LocalNotification(){
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async =>
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenNavigation()),
      );

  void showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  scheduleNotification(String foodName, DateTime expiryDate, int id) async {
    print("Scheduling notifications.");
    expiryDate.add(new Duration(hours: 10)); //user will be notified at 10am
    DateTime formattedExpiryDate = new DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    DateTime now = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime sevenDaysInAdvance = new DateTime(now.year, now.month, now.day).add(new Duration(days: 7));
    var scheduledNotificationDateTime;
    var message;
    if(formattedExpiryDate.isBefore(sevenDaysInAdvance)){
      if(formattedExpiryDate != now){
        scheduledNotificationDateTime = expiryDate.subtract(new Duration(days: 1));
       // scheduledNotificationDateTime = DateTime.now().add(new Duration(seconds: 30));
        message = '$foodName will expire in 1 day.';
      }
    }
    else{
      scheduledNotificationDateTime = expiryDate.subtract(new Duration(days: 3));
     // scheduledNotificationDateTime = DateTime.now().add(new Duration(seconds: 30));
      message = '$foodName will expire in 3 days.';
    }
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your other channel id',
        'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id,
        'Hey you have food about to expire!',
        message,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}