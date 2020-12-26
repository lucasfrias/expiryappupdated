import 'dart:convert';
import 'package:expiryapp/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';

import '../database_helper.dart';
import '../food_item.dart';
import '../local_notification.dart';
import '../product.dart';
import '../utility.dart';
import 'addFoodToPantryScreen.dart';
import 'info_page_swipe.dart';

class Pantry extends StatefulWidget {
  @override
  _PantryState createState() => _PantryState();
}

class _PantryState extends State<Pantry> {
  LocalNotification localNotifications;

  @override
  void initState() {
    localNotifications = new LocalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initiate(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pantry',
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
              onPressed: () async {
                ConfirmAction action = await Utility.asyncAddFoodDialog(context);
                setState(() {
                  if (action == ConfirmAction.SCANNER) {
                    //addProduct();
                    test();
                  }
                  else if(action == ConfirmAction.MANUAL){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFoodToPantryScreen()
                      ),
                    );
                  }
                });
              },
            )
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoPage()),
              );
            },
            child: Icon(
              Icons.info,
            ),
          ),
        ),
        body: FutureBuilder<List<FoodItem>>(
            future: DatabaseHelper.instance.retrieveNonExpiredFoods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  //return Text("test");
                  return Center(
                      child: SizedBox(
                    width: 350.0,
                    child: TypewriterAnimatedTextKit(
                      isRepeatingAnimation: false,
                      text: [
                        "There's no food in your pantry!",
                        "Add some food by,",
                        "Clicking the camera button in the top right.",
                        "And scanning a barcode!"
                      ],
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
                            _deleteFood(snapshot.data[index]);
                          },
                          background: Container(
                              // padding: EdgeInsets.only(right: 10),
                              //alignment: AlignmentDirectional.centerEnd,
                              color: Colors.redAccent,
                              child: Icon(Icons.delete_forever,
                                  color: Colors.white)),
                          child: Card(
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      snapshot.data[index].imageUrl !=
                                              "fork.png"
                                          ? NetworkImage(
                                              snapshot.data[index].imageUrl)
                                          : AssetImage(
                                              'assets/images/fork.png'),
                                ),
                                title: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(
                                      fontFamily: 'Times New Roman',
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                    'Expires: ' +
                                        Utility.formatISO(snapshot
                                            .data[index].expirationDate),
                                    style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 13)),
                                /*onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(),
                                        // Pass the arguments as part of the RouteSettings. The
                                        // DetailScreen reads the arguments from these settings.
                                        settings: RouteSettings(
                                          arguments: snapshot.data[index],
                                        ),
                                      ),
                                    );
                                  },*/
                              )));
                    },
                  );
                }
              } else if (snapshot.hasError) {
                return Text("Error!" + snapshot.error.toString());
              }
              return CircularProgressIndicator();
            }),
        /*floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black38,
            elevation: 10.0,
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                test();
                //addProduct();
              });
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop*/
    );
  }

  Future<void> test() async{
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFoodToPantryScreen(),
        settings: RouteSettings(
          arguments: localNotifications,
        )
      ),
    );*/


    //var date = await Utility.selectDate(context);
    var date = new DateTime.now().add(new Duration(days: 3));
    var food = new FoodItem(name: "White Bread",
        imageUrl: "https://www.browneyedbaker.com/wp-content/uploads/2016/05/white-bread-53-600-600x900.jpg",
        //"BlankImage.png", "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg",
       expirationDate: date.toIso8601String(),
        expired: false);
    FoodItem result = await DatabaseHelper.instance.addFood(food);
    setState(()  {});
    localNotifications.scheduleNotification(food.name, date, result.id);
  }

  Future<void> addProduct() async {
    try {
      var barcode = await barcodeScanning();
      // ignore: null_aware_in_logical_operator
      if (barcode?.isNotEmpty && barcode != null && barcode != "-1") {
        var product = await fetchProduct(barcode);
        if (product.statusCode != "0" || product != null) {
          try {
            if (product.imageUrl.isEmpty || product.imageUrl == null) {
              product.imageUrl = "fork.png";
            }
            var expirationDate = await Utility.selectDate(context);
            if (expirationDate != null) {
              FoodItem result = await DatabaseHelper.instance.addFood(
                  new FoodItem(
                      name: product.name,
                      imageUrl: product.imageUrl,
                      expirationDate: expirationDate.toIso8601String(),
                      expired: false));
              setState(() {});
              print("\nScheduled notification");
              localNotifications.scheduleNotification(
                  product.name, expirationDate, result.id);
              print("\nSuccessfully added item!");
            }
          } catch (e) {}
        }
      }
    } catch (e) {
      ConfirmAction action = await Utility.asyncManualBarcodeDialog(context);
      if (action == ConfirmAction.ACCEPT) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddFoodToPantryScreen(),
          ),
        );
      }
    }
  }

  _deleteFood(FoodItem food) async {
    ConfirmAction action = await Utility.asyncConfirmDialog(
        context, 'Delete ${food.name} from pantry?', 'Delete food?');
    setState(() {
      if (action == ConfirmAction.ACCEPT) {
        DatabaseHelper.instance.deleteFood(food.id);
        print("\nDeleting notification id: " + food.id.toString());
        localNotifications.cancelNotification(food.id);
      }
    });
  }
}

Future<String> barcodeScanning() async {
  try {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.BARCODE);
    return barcode != null ? barcode : null;
  } on PlatformException catch (e) {
    throw Exception('Unknown error: $e');
  } on FormatException {
    throw Exception('Nothing captured.');
  } catch (e) {
    throw Exception('Unknown error: $e');
  }
}

Future<Product> fetchProduct(String barcode) async {
  final response = await http
      .get('https://us-en.openfoodfacts.org/api/v0/product/' + barcode);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Product.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

/*class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FoodItem food = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(food.name),
        ),
        body: new ListView(
          children: <Widget>[
            food.imageUrl != "BlankImage.png" ? Image.network(food.imageUrl, fit: BoxFit.scaleDown) : Image.asset('assets/images/BlankImage.png', fit: BoxFit.scaleDown),
            new Text('Expiration Date = ' + food.expirationDate)
          ],
        )
    );
  }
}*/
