import 'dart:async';

import 'package:meals/models/meal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _dbName = 'meals.db';
  static const _table = 'favorites';

  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_table (
            id TEXT PRIMARY KEY,
            categories TEXT,
            title TEXT,
            imageUrl TEXT,
            ingredients TEXT,
            steps TEXT,
            duration INTEGER,
            isGlutenFree INTEGER,
            isLactoseFree INTEGER,
            isVegan INTEGER,
            isVegetarian INTEGER,
            complexity INTEGER,
            cost INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertMeal(Meal meal) async {
    final db = await _getDatabase();
    await db.insert(
      _table,
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeMeal(String id) async {
    final db = await _getDatabase();
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Meal>> getMeals() async {
    final db = await _getDatabase();
    final data = await db.query(_table);
    return data.map((item) => Meal.fromMap(item)).toList();
  }

  static Future<bool> isFavorite(String id) async {
    final db = await _getDatabase();
    final result = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
