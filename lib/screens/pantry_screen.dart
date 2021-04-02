import 'dart:convert';
import 'package:expiryapp/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../database_helper.dart';
import '../food_item.dart';
import '../local_notification.dart';
import '../product.dart';
import '../utility.dart';
import 'addFoodToPantryScreen.dart';
import 'expirationDatePickerScreen.dart';
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
        title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                height: 50,
                child: AutoSizeText(
                  'Pantry',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Times New Roman',
                      fontSize: 50),
                  maxLines: 1,
                ),
              ),
            ]),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
            onPressed: () async {
              ConfirmAction action = await Utility.asyncAddFoodDialog(context);
              if (action == ConfirmAction.SCANNER) {
                await addProduct();
                //test();
              } else if (action == ConfirmAction.MANUAL) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddFoodToPantryScreen(),
                      settings: RouteSettings(
                        arguments: localNotifications,
                      )),
                );
              }
              setState(() {});
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
                  height: 150.0,
                  child: FadeAnimatedTextKit(
                    isRepeatingAnimation: false,
                    text: [
                      "There's no food in your pantry!",
                      "Add some food by...",
                      "Clicking the camera button in the top right."
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
                                    snapshot.data[index].imageUrl != "fork.png"
                                        ? NetworkImage(
                                            snapshot.data[index].imageUrl)
                                        : AssetImage('assets/images/fork.png'),
                              ),
                              title: Text(
                                snapshot.data[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18),
                              ),
                              subtitle: Text(
                                  'Expires: ' +
                                      Utility.formatISO(
                                          snapshot.data[index].expirationDate),
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
              return Text("Oops something went wrong..");
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

  Future<void> test() async {
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
    /*
    var date = new DateTime.now().add(new Duration(days: 3));
    var food = new FoodItem(name: "White bread",
        imageUrl: "https://www.browneyedbaker.com/wp-content/uploads/2016/05/white-bread-53-600-600x900.jpg",
        //"BlankImage.png", "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg",
       expirationDate: date.toIso8601String(),
        expired: false);

    var date2 = new DateTime.now().add(new Duration(days: 14));
    var food2 = new FoodItem(name: "Chicken",
        imageUrl: "https://images-gmi-pmc.edge-generalmills.com/7ed1e04a-7ac6-4ca2-aa74-6c0938069062.jpg",
        expirationDate: date2.toIso8601String(),
        expired: false);

    var date3 = new DateTime.now().add(new Duration(days: 5));
    var food3 = new FoodItem(name: "Lasagna",
        imageUrl: "https://www.thewholesomedish.com/wp-content/uploads/2018/07/Best-Lasagna-550-500x500.jpg",
        expirationDate: date3.toIso8601String(),
        expired: false);

    var date4 = new DateTime.now().add(new Duration(days: 27));
    var food4 = new FoodItem(name: "Eggs",
        imageUrl: "https://www.wishtv.com/wp-content/uploads/2020/03/CROP-Eggs-hypatia-h_bcdda256340f68287a2e0ebced64dac0-h_b422392013797decae81d659f46ca31e.jpg",
        expirationDate: date4.toIso8601String(),
        expired: false);

    /*food.imageUrl = null;
    if(food.imageUrl == null){
      food.imageUrl = 'fork.png';
    }
     */

    FoodItem result = await DatabaseHelper.instance.addFood(food);
    FoodItem result2 = await DatabaseHelper.instance.addFood(food2);
    FoodItem result3 = await DatabaseHelper.instance.addFood(food3);
    FoodItem result4 = await DatabaseHelper.instance.addFood(food4);

    */

    /*
    var date = new DateTime.now().subtract(new Duration(days: 5));
    var food = new FoodItem(name: "Orange juice",
        imageUrl: "https://img1.mashed.com/img/gallery/this-is-the-maximum-amount-of-orange-juice-you-should-drink-each-day/intro-1585587621.jpg",
        //"BlankImage.png", "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg",
        expirationDate: date.toIso8601String(),
        expired: true);

    var date2 = new DateTime.now().subtract(new Duration(days: 3));
    var food2 = new FoodItem(name: "Cookie dough",
        imageUrl: "https://prettysimplesweet.com/wp-content/uploads/2020/06/Cookie-Dough.jpg",
        expirationDate: date2.toIso8601String(),
        expired: true);

    var date3 = new DateTime.now().subtract(new Duration(days: 2));
    var food3 = new FoodItem(name: "Ground beef",
        imageUrl: "https://www.perishablenews.com/wp-content/uploads/2019/04/m11-2.jpg",
        expirationDate: date3.toIso8601String(),
        expired: true);


    FoodItem result = await DatabaseHelper.instance.addFood(food);
    FoodItem result2 = await DatabaseHelper.instance.addFood(food2);
    FoodItem result3 = await DatabaseHelper.instance.addFood(food3);

    setState(()  {});

    */

    //localNotifications.scheduleNotification(food.name, date, result.id);
  }

  Future<void> addProduct() async {
    try {
      //var barcode = "078732910021"; //doesnt exist
      //var barcode = "0787359100215"; //food with no image
      //var barcode = "737628064502"; //food with image
      var barcode = await barcodeScanning();
      print('Barcode read: ' + barcode);
      // ignore: null_aware_in_logical_operator
      if (barcode?.isNotEmpty && barcode != null && barcode != "-1") {
        var product = await fetchProduct(barcode);
        /*var product = new Product(
          name: "test",
          statusCode: "0"
        );
         */
        print('Product Details:'
                '\nName ' +
            product.name +
            '\nImageUrl: ' +
            product.imageUrl +
            '\nStatusCode: ' +
            product.statusCode);
        product.imageUrl ??= 'fork.png';
        if (product.statusCode != "0" || product != null) {
          final expirationDate = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpirationDateScreen(),
              ));
          if (expirationDate != null) {
            //hardcode name sometimes food name comes empty from API
            if (product.name.isEmpty || product.name == null) {
              product.name = 'Food';
            }
            FoodItem result = await DatabaseHelper.instance.addFood(
                new FoodItem(
                    name: product.name,
                    imageUrl: product.imageUrl,
                    expirationDate: expirationDate.toIso8601String(),
                    expired: false));

            print('Result imageurl: ' + result.imageUrl);
            result.imageUrl ??= 'fork.png';
            setState(() {});
            localNotifications.scheduleNotification(
                product.name, expirationDate, result.id);
            print("\nSuccessfully added item!");
          }
        }
      }
    } catch (e) {
      ConfirmAction action = await Utility.asyncManualBarcodeDialog(context);
      if (action == ConfirmAction.ACCEPT) {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddFoodToPantryScreen(),
              settings: RouteSettings(
                arguments: localNotifications,
              )),
        );
        setState(() {});
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
