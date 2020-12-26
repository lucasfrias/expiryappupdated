import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizeConfig.dart';
import '../database_helper.dart';
import '../grocery_item.dart';

class AddGroceryItemScreen extends StatefulWidget {
  @override
  AddGroceryItemScreenState createState() {
    return new AddGroceryItemScreenState();
  }
}

class AddGroceryItemScreenState extends State<AddGroceryItemScreen> {
  final _text = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initiate(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add to grocery list',
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              height: 0.3,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              //fontStyle: FontStyle.italic,
              fontFamily: 'Times New Roman',
              fontSize: SizeConfig.safeBlockHorizontal * 9),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
            child: TextField(
              style: TextStyle(
               // height: .5,
                  fontSize: 23,
                  color: Colors.black45,
                  fontFamily: 'Times New Roman'),
              controller: _text,
              decoration: InputDecoration(
                //contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                border: OutlineInputBorder(),
                labelText: 'Enter the name of your food.',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
            )
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  _text.text.isEmpty ? _validate = true : _validate = false;
                  if(!_validate && _text.text.isNotEmpty){
                    DatabaseHelper.instance.addGroceryItem(new GroceryItem(name: _text.text));
                    Navigator.pop(context);
                  }
                });
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