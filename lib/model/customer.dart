import 'package:sqflite_dog/model/base_entity.dart';

class Customer extends BaseEntity {
  final int id;
  final String name;

  Customer(
    this.id,
    this.name,
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Customer fromMap(Map<String, dynamic> json) {
    return Customer(
      json['id'],
      json["name"],
    );
  }

  String getPrimaryKey() {
    return 'id';
  }
}
