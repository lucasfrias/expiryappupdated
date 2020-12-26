
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizeConfig.dart';
import '../database_helper.dart';
import '../grocery_item.dart';
import '../utility.dart';
import 'addGroceryItemScreen.dart';

class GroceryList extends StatefulWidget {
  @override
  _GroceryList createState() => _GroceryList();
}

class _GroceryList extends State<GroceryList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initiate(context);
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              alignment: Alignment.center,
              iconSize: 35,
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _addGroceryItem();
                });
              },
            ),
          ],
          title: Text(
            'Grocery List',
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
        body: FutureBuilder<List<GroceryItem>>(
            future: DatabaseHelper.instance.retrieveGroceryList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Center(
                      child: SizedBox(
                      width: 360.0,
                      child: TypewriterAnimatedTextKit(
                      isRepeatingAnimation: false,
                      text: [
                      "Nothing in your grocery list.",
                      "Click the plus button to add an item.",
                      "So next time you go shopping you won't forget!"
                      ],
                      textStyle: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Times New Roman"
                  ),
              ),
              )
              );
                }
                else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                            title: Text(snapshot.data[index].name,
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                  fontSize: 20
                              )
                            ),
                            trailing: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                ConfirmAction action = await Utility.asyncConfirmDialog(context, 'Delete ' + snapshot.data[index].name +
                                    ' from grocery list?', 'Delete food?');
                                setState(() {
                                  setState(() {
                                    if (action == ConfirmAction.ACCEPT) {
                                      DatabaseHelper.instance.deleteGroceryItem(snapshot.data[index].id);
                                    }
                                  });
                                });
                                },
                          ),
                      )
                      );
                    },
                  );
                }
              } else if (snapshot.hasError) {
                return Text("Error!" + snapshot.error.toString());
              }
              return CircularProgressIndicator();
            }
        ),
        /*floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black38,
            elevation: 10.0,
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _addGroceryItem();
              });
            }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .endTop*/
    );
  }

  _addGroceryItem(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGroceryItemScreen(),
      ),
    );
  }
}
