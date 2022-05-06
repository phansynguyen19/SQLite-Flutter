import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class DBUtils {
  static Database? db;
  static Future<void> init() async {
    db = await openDatabase(
      p.join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE User(id INTEGER PRIMARY KEY, name TEXT, name_eng TEXT, age INTEGER)',
        );
        db.execute(
          'CREATE TABLE Customer(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
      version: 1,
    );
  }
}
