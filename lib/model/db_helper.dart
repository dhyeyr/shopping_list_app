import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _obj = DbHelper._helper();

  DbHelper._helper();

  final dbName = "quote_new.db";
  final String balanceTableName = "favorite_quote";
  Database? database;

  factory DbHelper() {
    return _obj;
  }

  static DbHelper get instance => _obj;

  Future<void> initDb() async {
    database = await openDatabase(
      dbName,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE "$balanceTableName" (
              "id" INTEGER PRIMARY KEY,
              "description" TEXT NOT NULL,
              "image" TEXT NOT NULL,
              "name" TEXT NOT NULL,
             "price" TEXT NOT NULL
            )''',
        );

        // "image" TEXT NOT NULL,
        // "name" TEXT NOT NULL,
        // "price" TEXT NOT NULL
      },
    );
  }

  Future<bool> insertData(String data) async {
    if (database == null) {
      await initDb();
    }

    List<Map<String, dynamic>> result = await database!.query(
      balanceTableName,
      where: 'content = ?',
      whereArgs: [data],
    );

    if (result.isEmpty) {
      await database!.insert(
        balanceTableName,
        {
          'content': data,
        },
      );
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getData() async {
    if (database == null) {
      await initDb();
    }
    return await database!.query(balanceTableName);
  }

  Future<void> deleteData(String data) async {
    if (database == null) {
      await initDb();
    }

    await database!.delete(
      balanceTableName,
      where: 'content = ?',
      whereArgs: [data],
    );
  }
}
