import 'package:expiryapp/screens/shelf_life_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_explanation_screen.dart';

class InfoPage extends StatefulWidget {
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: PageView(
        controller: controller,
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[ShelfLifeScreen(), DateExpirationScreen()],
      ),
    ));
  }
}
