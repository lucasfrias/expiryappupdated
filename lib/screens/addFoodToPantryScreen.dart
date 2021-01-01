import 'dart:math';

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
  bool _validateDate = false;
  DateTime expirationDate;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalNotification localNotifications = ModalRoute.of(context).settings.arguments;
    SizeConfig().initiate(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add to pantry',
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              height: 0.3,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              //fontStyle: FontStyle.italic,
              fontFamily: 'Times New Roman',
              fontSize: SizeConfig.safeBlockHorizontal * 10),
        ),
      ),
      body: Builder(
        builder: (context) =>
            Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 400,
            child: TextField(
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.black45,
                    fontFamily: 'Times New Roman'),
                controller: _text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the name of your food.',
                  errorText: _validateText ? 'Name Can\'t Be Empty' : null,
                ),
              ),
          ),
          Align(
            alignment: Alignment(-0.88, -0.75),
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 5, 0),
                child: Text("Set expiration date",
                style: TextStyle(fontSize: 23, color: Colors.black45, fontFamily: 'Times New Roman')
                )
              ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      minimumYear: DateTime.now().year,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (dateTime) {
                        setState(() {
                          expirationDate = dateTime;
                        });
                      }
                  )
              ),
              RaisedButton(
                onPressed: () async {
                  setState(() {
                    _text.text.isEmpty
                        ? _validateText = true
                        : _validateText = false;
                  });

                  if(expirationDate.isBefore(DateTime.now()) && expirationDate != (DateTime.now())){
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Date must be after today!',textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Times New Roman',)),
                          backgroundColor: Colors.red,
                        )
                    );
                  }
                  else if(!_validateText && _text.text.isNotEmpty){

                    // var expirationDate = await Utility.selectDate(context);
                   /* final expirationDate = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpirationDateScreen(),
                        )
                    );

                    */
                    if (expirationDate != null) {
                      FoodItem result = await DatabaseHelper.instance.addFood(
                          new FoodItem(
                              name: _text.text,
                              imageUrl: "fork.png",
                              expirationDate: expirationDate.toString(),
                              expired: false));
                      setState(() {});
                      localNotifications.scheduleNotification(
                          _text.text, expirationDate, result.id);
                      print("\nSuccessfully added item!");
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Submit'),
                textColor: Colors.white,
                color: Colors.black45,
              ),
            ],
          ),
        ],

      ),
      )
    );
  }
}