// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DbHelper {
//   static final DbHelper _obj = DbHelper._helper();
//
//   DbHelper._helper();
//
//   final dbName = "quote_new.db";
//   final String balanceTableName = "favorite_quote";
//   Database? database;
//
//   factory DbHelper() {
//     return _obj;
//   }
//
//   static DbHelper get instance => _obj;
//
//   Future<void> initDb() async {
//     database = await openDatabase(
//       dbName,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute(
//           '''CREATE TABLE "$balanceTableName" (
//               "id" INTEGER PRIMARY KEY,
//               "description" TEXT NOT NULL,
//               "image" TEXT NOT NULL,
//               "name" TEXT NOT NULL,
//              "price" TEXT NOT NULL
//             )''',
//         );
//
//         // "image" TEXT NOT NULL,
//         // "name" TEXT NOT NULL,
//         // "price" TEXT NOT NULL
//       },
//     );
//   }
//
//   Future<void> insertData(String name,String image,String price,String desc) async {
//     var db = await openDatabase(dbName);
//
//     List<Map<String, dynamic>> result = await db.query(
//       balanceTableName,
//       where: 'name = ? AND image = ? AND price = ? AND description = ?',
//       whereArgs: [name,image,price,desc],
//     );
//
//     if (result.isEmpty) {
//       await db.insert(
//         balanceTableName,
//         {
//           'name':name,
//           'image':image,
//           'price':price,
//           'description':desc
//         },
//       );
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getData() async {
//     if (database == null) {
//       await initDb();
//     }
//     return await database!.query(balanceTableName);
//   }
//
//   Future<void> deleteData(String data) async {
//     if (database == null) {
//       await initDb();
//     }
//
//     await database!.delete(
//       balanceTableName,
//       where: 'content = ?',
//       whereArgs: [data],
//     );
//   }
// }
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _obj = DbHelper._helper();

  DbHelper._helper();

  final dbname = 'products.db';

  factory DbHelper() {
    return _obj;
  }

  static DbHelper get instance => _obj;

  Database? database;

  Future<void> initDb() async {
    database = await openDatabase(
      dbname,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE "Product" ('
              '"id" INTEGER, '
              '"name" TEXT NOT NULL, '
              '"description" TEXT NOT NULL, '
              '"image" TEXT , '
              '"price" NUMERIC NOT NULL , '
              'PRIMARY KEY("id" AUTOINCREMENT))',
        );
      },
      singleInstance: true,
    );
  }

  Future<void> insertProduct(String name, String description, String image, String price) async {
    var db = await openDatabase(dbname);
    List<Map<String, dynamic>> result = await db.query(
      'Product',
      where: 'name = ? AND description = ? AND image = ? AND price = ?',
      whereArgs: [name, description,image,price],
    );

    // If the quote doesn't exist, insert it into the database
    if (result.isEmpty) {
      await db.insert(
        'Product',
        {
          'name': name,
          'description': description,
          'image': image, // Include the image path in the database entry
          'price': price, // Include the image path in the database entry
        },
      );
    } else {
      // Quote already exists, handle accordingly
      print('Quote already exists in the database');
    }
  }

  Future<List<Map<String, Object?>>> GetProduct() async {
    var db = await openDatabase(dbname);
    return await db.query('Product');
  }

  Future<List<Map<String, dynamic>>> getData() async {
    if (database == null) {
      await initDb();
    }
    return await database!.query(dbname);
  }

  Future<void> deleteData(String data) async {
    if (database == null) {
      await initDb();
    }

    await database!.delete(
      dbname,
      where: 'content = ?',
      whereArgs: [data],
    );
  }
}