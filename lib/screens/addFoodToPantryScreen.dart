import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../SizeConfig.dart';
import '../database_helper.dart';
import '../food_item.dart';
import '../utility.dart';
import '../local_notification.dart';

class AddFoodToPantryScreen extends StatefulWidget {
  @override
  AddFoodToPantryScreenState createState() {
    return new AddFoodToPantryScreenState();
  }
}

class AddFoodToPantryScreenState extends State<AddFoodToPantryScreen> {
  final _text = TextEditingController();
  bool _validate = false;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'Times New Roman'),
              controller: _text,
              decoration: InputDecoration(
                labelText: 'Enter the name of your food.',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
            RaisedButton(
              onPressed: () async {
                setState(() {
                  _text.text.isEmpty ? _validate = true : _validate = false;
                });

                if(!_validate && _text.text.isNotEmpty){
                  var expirationDate = await Utility.selectDate(context);
                  if(expirationDate != null){
                    FoodItem foodItem = new FoodItem(name:_text.text,
                        imageUrl: "fork.png",
                        expirationDate: expirationDate.toIso8601String(),
                        expired: false);
                    FoodItem result = await DatabaseHelper.instance.addFood(foodItem);
                    localNotifications.scheduleNotification(foodItem.name, expirationDate, result.id);
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('Submit'),
              textColor: Colors.white,
              color: Colors.black45,
            )
          ],
        ),
      ),
    );
  }
}