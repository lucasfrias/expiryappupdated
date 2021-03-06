import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../SizeConfig.dart';
import '../database_helper.dart';
import '../food_item.dart';
import '../grocery_item.dart';
import '../utility.dart';

class ExpiredFood extends StatefulWidget {
  @override
  _ExpiredFoodState createState() => _ExpiredFoodState();
}

class _ExpiredFoodState extends State<ExpiredFood> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initiate(context);
    return Scaffold(
        appBar: AppBar(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  height: 50,
                  child: AutoSizeText(
                    'Expired',
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
        body: FutureBuilder<List<FoodItem>>(
            future: DatabaseHelper.instance.retrieveExpiredFoods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Center(
                      child: SizedBox(
                    width: 350.0,
                    height: 150.0,
                    child: FadeAnimatedTextKit(
                      isRepeatingAnimation: false,
                      text: ["When items expire they will show up here."],
                      textStyle: TextStyle(
                          fontSize: 30.0, fontFamily: "Times New Roman"),
                    ),
                  ));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            _deleteFood(context, snapshot.data[index].id,
                                snapshot.data[index].name);
                          },
                          background: Container(
                              // padding: EdgeInsets.only(right: 10),
                              //alignment: AlignmentDirectional.centerEnd,
                              color: Colors.redAccent,
                              child: Icon(Icons.delete_forever,
                                  color: Colors.white)),
                          child: Card(
                              child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: snapshot.data[index].imageUrl !=
                                      "fork.png"
                                  ? NetworkImage(snapshot.data[index].imageUrl)
                                  : AssetImage('assets/images/fork.png'),
                            ),
                            title: Text(snapshot.data[index].name,
                                style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18)),
                            subtitle: Text(
                                "Expired " +
                                    DateTime.now()
                                        .difference(DateTime.parse(snapshot
                                            .data[index].expirationDate))
                                        .inDays
                                        .toString() +
                                    " day(s) ago",
                                style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 13,
                                    color: Colors.redAccent)),
                            /*style: GoogleFonts.permanentMarker(
                                textStyle: TextStyle(),
                                color: Colors.redAccent)),*/
                            trailing: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () async {
                                  ConfirmAction action =
                                      await Utility.asyncConfirmDialog(
                                          context,
                                          'Move ' +
                                              snapshot.data[index].name +
                                              ' to grocery list?',
                                          'Transfer Food?',
                                          switchColor: true);
                                  setState(() {
                                    if (action == ConfirmAction.ACCEPT) {
                                      DatabaseHelper.instance.addGroceryItem(
                                          new GroceryItem(
                                              name: snapshot.data[index].name));
                                      DatabaseHelper.instance
                                          .deleteFood(snapshot.data[index].id);
                                    }
                                  });
                                }),
                          )));
                    },
                  );
                }
              } else if (snapshot.hasError) {
                return Text("Error!" + snapshot.error.toString());
              }
              return CircularProgressIndicator();
            }));
  }

  _deleteFood(BuildContext context, int id, String name) async {
    ConfirmAction action = await Utility.asyncConfirmDialog(
        context, 'Delete $name from expired list?', 'Delete food?');
    setState(() {
      if (action == ConfirmAction.ACCEPT) {
        DatabaseHelper.instance.deleteFood(id);
      }
    });
  }
}
