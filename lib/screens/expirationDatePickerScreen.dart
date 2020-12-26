import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database_helper.dart';
import '../food_item.dart';

class ExpirationDateScreen extends StatefulWidget {
  @override
  ExpirationDateScreenState createState() {
    return new ExpirationDateScreenState();
  }
}

class ExpirationDateScreenState extends State<ExpirationDateScreen>{
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (dateTime){
                print(dateTime);
                setState(() {
                  _dateTime = dateTime;
                });
              }
            ),
          ),
          RaisedButton(
            child: Text('Confirm'),
            onPressed: () {
              setState(() {
                if(_dateTime != null){
                  Navigator.pop(context, _dateTime);
                }
              });
            },
          )
        ],
      )
    );
  }



}