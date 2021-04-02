import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizeConfig.dart';
import '../database_helper.dart';
import '../food_item.dart';
import '../utility.dart';
import '../local_notification.dart';
import 'expirationDatePickerScreen.dart';

class AddFoodToPantryScreen extends StatefulWidget {
  @override
  AddFoodToPantryScreenState createState() {
    return new AddFoodToPantryScreenState();
  }
}

class AddFoodToPantryScreenState extends State<AddFoodToPantryScreen> {
  final _text = TextEditingController();
  bool _validateText = false;
  DateTime expirationDate;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalNotification localNotifications =
        ModalRoute.of(context).settings.arguments;
    SizeConfig().initiate(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  height: 50,
                  child: AutoSizeText(
                    'Add to pantry',
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
        body: Builder(
            builder: (context) => Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 10,
                          child: Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(20),
                              //width: 400,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: ListView(shrinkWrap: true, children: <
                                      Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        TextField(
                                          style: TextStyle(
                                              fontSize: 23,
                                              color: Colors.black45,
                                              fontFamily: 'Times New Roman'),
                                          controller: _text,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                'Enter the name of your food.',
                                            errorText: _validateText
                                                ? 'Name can\'t be empty'
                                                : null,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 50, 5, 0),
                                              child: Text("Set expiration date",
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      color: Colors.black45,
                                                      fontFamily:
                                                          'Times New Roman'))),
                                        ),
                                        SizedBox(
                                            height: 200,
                                            width: 300,
                                            child: CupertinoDatePicker(
                                                initialDateTime: DateTime.now(),
                                                minimumYear:
                                                    DateTime.now().year,
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                onDateTimeChanged: (dateTime) {
                                                  setState(() {
                                                    expirationDate = dateTime;
                                                  });
                                                })),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 50, 5, 0),
                                              child: CupertinoButton(
                                                child: Text(
                                                  'Add',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontFamily:
                                                          'Times New Roman'),
                                                ),
                                                color: Color(0xFF2E8B57),
                                                onPressed: () async {
                                                  setState(() {
                                                    _text.text.isEmpty
                                                        ? _validateText = true
                                                        : _validateText = false;
                                                  });

                                                  if (expirationDate == null ||
                                                      expirationDate.isBefore(
                                                          DateTime.now())) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Date must be after today',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'Times New Roman',
                                                          )),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ));
                                                  } else if (!_validateText &&
                                                      _text.text.isNotEmpty) {
                                                    if (expirationDate !=
                                                        null) {
                                                      FoodItem result = await DatabaseHelper
                                                          .instance
                                                          .addFood(new FoodItem(
                                                              name: _text.text,
                                                              imageUrl:
                                                                  "fork.png",
                                                              expirationDate:
                                                                  expirationDate
                                                                      .toString(),
                                                              expired: false));
                                                      setState(() {});
                                                      localNotifications
                                                          .scheduleNotification(
                                                              _text.text,
                                                              expirationDate,
                                                              result.id);
                                                      print(
                                                          "Successfully added item!");
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                },
                                              ),
                                            )),
                                      ],
                                    ),
                                  ]))))
                    ])));
  }
}
