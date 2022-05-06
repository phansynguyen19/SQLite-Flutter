import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sqflite_dog/home_page.dart';
import 'package:sqflite_dog/model/customer.dart';
import 'package:sqflite_dog/model/user.dart';
import 'package:sqflite_dog/utils/db_utils.dart';
import 'package:diacritic/diacritic.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Open the database and store the reference.
  await DBUtils.init();

  // Create a Dog and add it to the dogs table
  var customer1 = Customer(0, 'Shoppe');
  var customer2 = Customer(1, 'Lazada');
  List<Customer> customerList = [];
  customerList.add(customer1);
  customerList.add(customer2);

  for (var item in customerList) {
    item.insert();
  }

  var fido = User(
    0,
    'O Nguyen',
    removeDiacritics('O lá la'),
    35,
  );
  var fido2 = User(
    1,
    'O Nguyên le',
    removeDiacritics('O Nguyên le'),
    36,
  );
  List<User> list = [];
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  for (var i = 0; i < 100; i++) {
    String name = getRandomString(10);
    var user = User(
      i,
      name,
      removeDiacritics(name),
      i + 10,
    );
    list.add(user);
  }

  list.add(fido);
  list.add(fido2);

  for (var item in list) {
    item.insert();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme:
              const TextTheme(headline6: TextStyle(color: Colors.white))),
      home: const HomePage(),
    );
  }
}
