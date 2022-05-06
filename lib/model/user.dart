import 'package:sqflite_dog/model/base_entity.dart';

class User extends BaseEntity {
  int id;
  String name;
  // ignore: non_constant_identifier_names
  String name_eng;
  int age;

  User(
    this.id,
    this.name,
    this.name_eng,
    this.age,
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_eng': name_eng,
      'age': age,
    };
  }

  static User fromMap(Map<String, dynamic> json) {
    return User(
      json['id'],
      json["name"],
      json["name_eng"],
      json["age"],
    );
  }

  String getPrimaryKey() {
    return 'id';
  }

  // @override
  // String toString() {
  //   return runtimeType.toString();
  // }
}
