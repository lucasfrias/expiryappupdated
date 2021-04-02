import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'food_item.dart';
import 'grocery_item.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static const databaseName = 'foods_database.db';
  static const groceryDatabaseName = 'grocery_databse.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;
  static Database _groceryDatabase;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  Future<Database> get groceryDatabase async {
    if (_groceryDatabase == null) {
      return await initializeGroceryDatabase();
    }
    return _groceryDatabase;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE foods(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, imageUrl TEXT, expirationDate TEXT, expired INTEGER)");
    });
  }

  initializeGroceryDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), groceryDatabaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE grocery(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT)");
    });
  }

  addGroceryItem(GroceryItem item) async {
    final db = await groceryDatabase;
    var res = await db.insert(GroceryItem.TABLENAME, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  deleteGroceryItem(int id) async {
    var db = await groceryDatabase;
    db.delete(GroceryItem.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<FoodItem> addFood(FoodItem food) async {
    final db = await database;
    food.id = await db.insert(FoodItem.TABLENAME, food.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return food;
  }

  deleteFood(int id) async {
    var db = await database;
    db.delete(FoodItem.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<GroceryItem>> retrieveGroceryList() async {
    final db = await groceryDatabase;

    final List<Map<String, dynamic>> maps =
        await db.query(GroceryItem.TABLENAME);

    return List.generate(maps.length, (i) {
      return GroceryItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<List<FoodItem>> _retrieveFoods() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(FoodItem.TABLENAME, orderBy: 'expirationDate ASC');

    List<FoodItem> foodList = List.generate(maps.length, (i) {
      return FoodItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imageUrl: maps[i]['imageUrl'],
        expirationDate: maps[i]['expirationDate'],
        expired: maps[i]['expired'] == 1,
      );
    });

    DateTime now = new DateTime.now();
    for (var food in foodList) {
      DateTime expiredDate = DateTime.parse(food.expirationDate);
      DateTime deleteDate =
          new DateTime(expiredDate.year, expiredDate.month, expiredDate.day)
              .add(new Duration(days: 7));
      if (new DateTime(now.year, now.month, now.day).isAfter(new DateTime(
              expiredDate.year, expiredDate.month, expiredDate.day)) &&
          (new DateTime(now.year, now.month, now.day)) !=
              new DateTime(
                  expiredDate.year, expiredDate.month, expiredDate.day)) {
        food.expired = true;
        if (new DateTime(now.year, now.month, now.day).isAfter(deleteDate))
          deleteFood(food.id);
      }
    }
    return foodList;
  }

  Future<List<FoodItem>> retrieveNonExpiredFoods() async {
    List<FoodItem> foodList = await DatabaseHelper.instance._retrieveFoods();
    return foodList.where((food) => food.expired != true).toList();
  }

  Future<List<FoodItem>> retrieveExpiredFoods() async {
    List<FoodItem> foodList = await DatabaseHelper.instance._retrieveFoods();
    return foodList.where((food) => food.expired == true).toList();
  }

  String _formatISO(String date) {
    var datetime = DateTime.parse(
        date.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]));
    return DateFormat.yMMMMd("en_US").format(datetime).toString();
  }

/*  updateFood(FoodItem food) async {
    final db = await database;

    await db.update(FoodItem.TABLENAME, food.toMap(),
        where: 'id = ?',
        whereArgs: [food.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }*/
}
