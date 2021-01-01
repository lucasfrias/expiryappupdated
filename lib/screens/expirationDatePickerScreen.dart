import 'package:expiryapp/utility.dart';
import 'package:flutter/cupertino.dart';
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

class ExpirationDateScreenState extends State<ExpirationDateScreen>{
  DateTime expirationDate;

  @override
  Widget build(BuildContext context) {
    SizeConfig().initiate(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            'Set Expiration Date',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              height: 0.3,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              //fontStyle: FontStyle.italic,
              fontFamily: 'Times New Roman',
              fontSize: SizeConfig.safeBlockHorizontal * 8),
        ),
      ),
      body: Builder (
        builder: (context) =>
            Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
                    } else{
                      Navigator.pop(context, expirationDate);
                    }
                  });
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