import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizeConfig.dart';

class DateExpirationScreen extends StatefulWidget {
  @override
  DateExpirationScreenState createState() {
    return new DateExpirationScreenState();
  }
}

class DateExpirationScreenState extends State<DateExpirationScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initiate(context);
    return new MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            appBarTheme: new AppBarTheme(color: Color(0xFF2E8B57)),
            scaffoldBackgroundColor: Color(0XffE0E8CF)),
        home: Scaffold(
            appBar: AppBar(
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      height: 50,
                      child: AutoSizeText(
                        'What is all this?',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Times New Roman',
                            fontSize: 50),
                        maxLines: 1,
                      ),
                    ),
                  ]),
            ),
            body: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          //width: 400,
                          child: Align(
                              //alignment: Alignment.center,
                              child:
                                  ListView(shrinkWrap: true, children: <Widget>[
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            _buildFruitCard(
                                "USE-BY & BEST BEFORE",
                                "assets/images/apple2.png",
                                "Provided voluntary by the manufacturer to let you know how long the product will reamin at its absolute best. "
                                    "The product is still edible after this date but the taste may decline.",
                                0xffF0BBBF),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            _buildFruitCard(
                                "EXPIRES ON",
                                "assets/images/apple2.png",
                                "Found on perishables like meat and dairy. This is a guide for stores to know how long they can display the product. "
                                    "You can eat the product beyond this date as long as it is stored properly.",
                                0xffF0AEAF),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            _buildFruitCard(
                                "SELL-BY",
                                "assets/images/apple2.png",
                                "This is usually found only on baby food or other products the government regulates with regard to dating. "
                                    "Do not consume past this date. ",
                                0xffF0AEAF)
                          ]))))
                ])));
  }

  _buildFruitCard(String name, String asset, String message, int color) {
    return Container(
        width: 90 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: Color(0xffECEDF1),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.green)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'OpenSans',
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontWeight: FontWeight.bold,
                      fontSize: 2 * SizeConfig.textMultiplier),
                ),
              ),
              SizedBox(
                height: 2 * SizeConfig.heightMultiplier,
              )
            ],
          ),
        )));
  }
}
