
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

  //Scheduling may or may not be be implemented. Problem occurs is food item is scheduled them deleted. Do not know if
  //there is a way to delete a specific notification. There is a cancel all notifications option but then i would constantly
  //create be checking if a food item was deleted and re-creating the scheduled notification.
  scheduleNotification(String foodName, DateTime expiryDate, int id) async {
    print("Scheduling notifications.");
    DateTime formattedExpiryDate = new DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    DateTime now = new DateTime.now();
    DateTime sevenDaysInAdvance = new DateTime(now.year, now.month, now.day).add(new Duration(days: 7));
    var scheduledNotificationDateTime;
    var message;
    if(formattedExpiryDate.isBefore(sevenDaysInAdvance)){
      //scheduledNotificationDateTime = expiryDate.subtract(new Duration(days: 3));
      scheduledNotificationDateTime = DateTime.now().add(new Duration(minutes: 1));
      message = '$foodName will expire in 3 days.';
    }
    else{
      //scheduledNotificationDateTime = expiryDate.subtract(new Duration(days: 7));
      scheduledNotificationDateTime = DateTime.now().add(new Duration(minutes: 1));
      message = '$foodName will expire in 7 days.';
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