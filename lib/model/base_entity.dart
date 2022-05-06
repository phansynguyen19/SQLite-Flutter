import 'package:diacritic/diacritic.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_dog/utils/db_utils.dart';

abstract class CoreBaseEntity {
  Map<String, dynamic> toMap();
  // fromMap(Map<String, dynamic> json);
}

class BaseEntity<T> implements CoreBaseEntity {
  String getTableName() {
    return runtimeType.toString();
  }

  Future<void> insert() async {
    await DBUtils.db!.insert(
      getTableName(),
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getAll() async {
    var result = await DBUtils.db!.rawQuery("SELECT * FROM ${T.toString()}");
    // return List.generate(result.length, (i) {
    //   return fromMap(result[i]);
    // });
    return result.toList();
  }

  Future<List> search(String query, String column1, String column2) async {
    String convertQuery = removeDiacritics(query);
    var result = await DBUtils.db!.rawQuery(
        'SELECT * FROM ${T.toString()} WHERE $column1 LIKE ? OR $column2 LIKE ?',
        ['%$convertQuery%', '%$convertQuery%']);

    return result.toList();
  }

  Future<List> search2(String query, String column1, String column2) async {
    String convertQuery = removeDiacritics(query);
    var result = await DBUtils.db!.rawQuery(
        'SELECT * FROM ${T.toString()} WHERE $column1 LIKE ?',
        ['%$convertQuery%', '%$convertQuery%']);

    return result.toList();
  }

  Future<void> update(T) async {
    await DBUtils.db!.update(
      getTableName(),
      T.toMap(),
      where: '${T.getPrimaryKey()} = ?',
      whereArgs: [T.id],
    );
  }

  Future<void> delete(T) async {
    await DBUtils.db!.delete(
      getTableName(),
      where: '${T.getPrimaryKey()} = ?',
      //whereArg to prevent SQL injection.
      whereArgs: [T.id],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

  // static fromMap(Map<String, dynamic> json) {
  //   throw UnimplementedError();
  // }
}
