import 'package:expiryapp/screen_navigation.dart';
import 'package:expiryapp/screens/shelf_life_screen.dart';
import 'package:flutter/material.dart';

import 'SizeConfig.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //final  Color mainBlack = Color(0xFF383838);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              theme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Colors.lightGreen),
              debugShowCheckedModeBanner: false,
              title: 'HomeScreen App',
              home: ScreenNavigation(),
            );
          },
        );
      },
    );
  }
/* @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.lightGreen
        ),
        home: ScreenNavigation()
      );
  }*/
}
