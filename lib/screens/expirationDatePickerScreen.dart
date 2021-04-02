import 'package:auto_size_text/auto_size_text.dart';
import 'package:expiryapp/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../SizeConfig.dart';
import '../database_helper.dart';
import '../food_item.dart';

class ExpirationDateScreen extends StatefulWidget {
  @override
  ExpirationDateScreenState createState() {
    return new ExpirationDateScreenState();
  }
}

class ExpirationDateScreenState extends State<ExpirationDateScreen> {
  DateTime expirationDate;

  @override
  Widget build(BuildContext context) {
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
                    'Set Expiration Date',
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 200,
                      width: 300,
                      child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          minimumYear: DateTime.now().year,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (dateTime) {
                            setState(() {
                              expirationDate = dateTime;
                            });
                          })),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 5, 0),
                        child: CupertinoButton(
                          child: Text(
                            'Set',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Times New Roman'),
                          ),
                          color: Color(0xFF2E8B57),
                          onPressed: () {
                            if (expirationDate == null ||
                                expirationDate.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Date must be after today!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Times New Roman',
                                    )),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              Navigator.pop(context, expirationDate);
                            }
                            setState(() {});
                          },
                        ),
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}
