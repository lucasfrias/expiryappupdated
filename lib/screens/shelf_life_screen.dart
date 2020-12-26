import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizeConfig.dart';

class ShelfLifeScreen extends StatefulWidget {
  ShelfLifeScreen({Key key, this.title}) : super(key: key);


  final String title;

  @override
  ShelfLifeScreenState createState() => ShelfLifeScreenState();
}

class ShelfLifeScreenState extends State<ShelfLifeScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initiate(context);
    return new MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            appBarTheme: new AppBarTheme(color: Color(0xFF2E8B57)),
            scaffoldBackgroundColor: Color(0XffE0E8CF)
        ),
        home: Scaffold(
          appBar: AppBar(
        title: Text(
          'Shelf Life',
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              height: 0.3,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'Times New Roman',
              fontSize: SizeConfig.safeBlockHorizontal * 10),
        ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _buildFruitCard("Apples", "assets/images/apple2.png",
                            "Pantry: 2-4 weeks\nRefrigerator: 1-2 months\nFreezer: 8-12 months", 0xffF0AEAF),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Cantaloupe", "assets/images/cantaloupe.png",
                            "Pantry: Until ripe\nRefrigerator: 1 week\nFreezer: 8-12 months", 0xffFFC498),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Lemons", "assets/images/lemon.png",
                            "Pantry: 2-4 weeks\nRefrigerator: 1-2 months\nFreezer: 3-4 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Strawberries", "assets/images/strawberry.png",
                            "Pantry: 1-2 days\nRefrigerator: 5-7 days\nFreezer: 6-8 months", 0xffF0AEAF),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Carrots", "assets/images/carrot.png",
                            "Pantry: Up to 4 days\nRefrigerator: 4-5 weeks\nFreezer: 8-12 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Green beans", "assets/images/green-beans.png",
                            "Pantry: 1 day (not recommended)\nRefrigerator: 1 week\nFreezer: 8-12 months", 0xffC4D4A3),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Potatoes", "assets/images/potato.png",
                            "Pantry: 1 month\nRefrigerator: 3-4 months\nFreezer: Do not freeze", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Butter", "assets/images/butter.png",
                            "Pantry: 10 days\nRefrigerator: 1-3 months\nFreezer: 6-9 months", 0xffFFC498),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Cheeses, Soft", "assets/images/softcheese.png",
                            "Pantry: Few hours\nRefrigerator: 2-4 months\nFreezer: 6-8 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Milk", "assets/images/milk.png",
                            "Pantry: Few hours\nRefrigerator: 5-7 days\nFreezer: 1 month", 0xffECEDF1),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Bacon", "assets/images/bacon.png",
                            "Pantry: 2 hours\nRefrigerator: 2 weeks\nFreezer: 4 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Chicken", "assets/images/chicken.png",
                            "Pantry: 2 hours\nRefrigerator: 1-2 days\nFreezer: 1 year", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Ham", "assets/images/ham.png",
                            "Pantry: 2 hours\nRefrigerator: 1 week\nFreezer: 6 months", 0xffFFC498),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Steak", "assets/images/steak.png",
                            "Pantry: 2 hours\nRefrigerator: 1-2 days\nFreezer: 6-8 months", 0xffFFC498),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Honey", "assets/images/honey.png",
                            "Pantry: Forever\nRefrigerator: Forever (not recommended)\nFreezer: Forever", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Mayonnaise", "assets/images/mayo.png",
                            "Pantry: 2-3 months\nRefrigerator: 1 year (2 months if opened)\nFreezer: Do not freeze", 0xffF7DFB9),

                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: <Widget>[
                        _buildFruitCard("Bananas", "assets/images/banana.png",
                            "Pantry: 2-7 days\nRefrigerator: 5-9 days\nFreezer: 2-3 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Grapes", "assets/images/grapes.png",
                            "Pantry: 3-5 days\nRefrigerator: 7-10 days\nFreezer: 3-5 months", 0xffECEDF1),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Peaches", "assets/images/peach.png",
                            "Pantry: Until ripe\nRefrigerator: 2-5 days\nFreezer: 8-12 months", 0xffFFC498),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Broccoli", "assets/images/broccoli.png",
                            "Pantry: 2 days\nRefrigerator: 7-14 days\nFreezer: 8-12 months", 0xffC4D4A3),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Cucumbers", "assets/images/cucumber.png",
                            "Pantry: 1-3 days\nRefrigerator: 1 week\nFreezer: 8-12 months", 0xffC4D4A3),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Lettuce", "assets/images/lettuce.png",
                            "Pantry: 1 day (not recommended)\nRefrigerator: 1 week\nFreezer: Do not freeze", 0xffC4D4A3),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Tomatoes", "assets/images/tomato.png",
                            "Pantry: 5-7 days\nRefrigerator: 2 weeks\nFreezer: 8-12 months", 0xffF0AEAF),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Cheeses, Hard", "assets/images/cheese.png",
                            "Pantry: 1-3 months\nRefrigerator: 2-4 months\nFreezer: 6-8 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Eggs", "assets/images/egg.png",
                            "Pantry: Few hours\nRefrigerator: 3-4 weeks\nFreezer: Do not freeze", 0xffFFC498),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Yogurt", "assets/images/frozen-yogurt.png",
                            "Pantry: Few hours\nRefrigerator: 2-3 weeks\nFreezer: 1-2 months", 0xffECEDF1),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Bologna", "assets/images/bologna.png",
                            "Pantry: 2 hours\nRefrigerator: 1-2 weeks\nFreezer: 2-3 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Fish", "assets/images/fish.png",
                            "Pantry: 2 hours\nRefrigerator: 1-2 days\nFreezer: 6-9 months", 0xffECEDF1),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Hamburger", "assets/images/burger.png",
                            "Pantry: 2 hours\nRefrigerator: 1-2 days\nFreezer: 6-8 months", 0xffFFC498),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Bread", "assets/images/bread.png",
                            "Pantry: 5-7 days\nRefrigerator: 1-2 weeks\nFreezer: 2-3 months", 0xffF7DFB9),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Ketchup", "assets/images/ketchup.png",
                            "Pantry: 1 year\nRefrigerator: 1 year\nFreezer: Do not freeze", 0xffF0AEAF),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        _buildFruitCard("Soda", "assets/images/soda.png",
                            "Pantry: 6-9 months (3-5 months for diet)\nRefrigerator: 6-9 months (2-5 days if opened)\nFreezer: Do not freeze", 0xffECEDF1),

                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),

    )
    );
  }

  _buildFruitCard(String name, String asset, String message, int color) {
    return Container(
      width: 42.5 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              height: 20 * SizeConfig.imageSizeMultiplier,
              width: 20 * SizeConfig.imageSizeMultiplier,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(name, style: TextStyle(
                fontFamily: 'OpenSans-Bold',
                fontWeight: FontWeight.bold,
                fontSize: 2.5 * SizeConfig.textMultiplier
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(message, style: TextStyle(
                fontFamily: 'OpenSans-Bold',
                fontWeight: FontWeight.bold,
                fontSize: 1.4 * SizeConfig.textMultiplier
            ),),
          ),
          SizedBox(height: 2 * SizeConfig.heightMultiplier,)
        ],
      ),
    );
  }

}