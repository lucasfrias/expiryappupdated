import 'package:expiryapp/screen_navigation.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //final  Color mainBlack = Color(0xFF383838);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.lightGreen
        ),
        home: ScreenNavigation()
      );
  }
}