import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
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
          title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  height: 50,
                  child: AutoSizeText(
                    'Add to grocery list',
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      //width: 400,
                      child: Align(
                          alignment: Alignment.center,
                          child: ListView(shrinkWrap: true, children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                        labelText:
                                            'Enter the name of your food.',
                                        errorText: _validate
                                            ? 'Name can\'t be empty'
                                            : null,
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 50, 5, 0),
                                      child: CupertinoButton(
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Times New Roman'),
                                        ),
                                        color: Color(0xFF2E8B57),
                                        onPressed: () {
                                          setState(() {
                                            _text.text.isEmpty
                                                ? _validate = true
                                                : _validate = false;
                                            if (!_validate &&
                                                _text.text.isNotEmpty) {
                                              DatabaseHelper.instance
                                                  .addGroceryItem(
                                                      new GroceryItem(
                                                          name: _text.text));
                                              Navigator.pop(context);
                                            }
                                          });
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ]))))
            ]));
  }
}
