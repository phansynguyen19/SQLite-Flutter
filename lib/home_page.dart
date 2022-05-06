import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sqflite_dog/model/base_entity.dart';
import 'package:sqflite_dog/model/customer.dart';
import 'package:sqflite_dog/model/user.dart';
import 'package:diacritic/diacritic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> usersList = [];
  final List<Customer> _customerList = [];
  final List<String> _customerName = [];
  List<User> _foundUsers = [];
  String dropdownValue = '';
  final searchController = TextEditingController();

  bool isShowSearch = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _getUser();
    _getCustomer();
    FlutterNativeSplash.remove();
  }

  _getCustomer() async {
    _customerList.clear();
    var list = await BaseEntity<Customer>().getAll();
    for (var item in list) {
      setState(() {
        var todoItem = Customer.fromMap(item);
        _customerList.add(todoItem);
        _customerName.add(todoItem.name);
      });
    }
    dropdownValue = _customerName.elementAt(0);
  }

  _searchUser(String query) async {
    List<User> results = [];
    if (query.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = usersList;
    } else {
      for (var user in usersList) {
        if (user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.name_eng.toLowerCase().contains(query.toLowerCase())) {
          results.add(user);
        }
      }
    }
    setState(() {
      _foundUsers = results;
    });
  }

  _getUser() async {
    isLoading = true;
    usersList.clear();
    _foundUsers.clear();
    var lists = await BaseEntity<User>().getAll();

    for (var item in lists) {
      setState(() {
        var todoItem = User.fromMap(item);
        usersList.add(todoItem);
      });
    }
    _foundUsers = usersList;
    if (usersList.isNotEmpty) {
      isLoading = false;
    }
  }

  _fetchUser() async {
    var fido = User(
      0,
      'A má mê',
      removeDiacritics('A má mê'),
      35,
    );
    var fido2 = User(
      1,
      'A me me',
      removeDiacritics('A me me'),
      36,
    );

    List<User> list = [];

    list.add(fido);
    list.add(fido2);

    for (var item in list) {
      item.insert();
    }

    _getUser();

    setState(() {});
  }

  _deleteUser(int id) async {
    var toRemove = [];
    for (var element in _foundUsers) {
      if (element.id == id) {
        element.delete(element);
        toRemove.add(element);
      }
    }
    _foundUsers.removeWhere((e) => toRemove.contains(e));
    usersList.removeWhere((e) => toRemove.contains(e));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          !isShowSearch
              ? SliverAppBar(
                  floating: true,
                  snap: true,
                  title: const Text("SQLite Flutter"),
                  actions: <Widget>[
                    _customerList.isNotEmpty
                        ? DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            dropdownColor: Colors.blue,
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: _customerName
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  // style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              );
                            }).toList(),
                          )
                        : const SizedBox(),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // showSearch(
                        //   context: context,
                        //   delegate: CustomSearchDelegate(),
                        // );
                        setState(() {
                          isShowSearch = true;
                        });
                      },
                    ),
                  ],
                )
              : SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        isShowSearch = false;
                        _searchUser('');
                        searchController.clear();
                      });
                    },
                  ),
                  title: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    controller: searchController,
                    cursorColor: Colors.white,
                    cursorHeight: 20,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: ' Nhập từ khóa',
                      hintStyle:
                          const TextStyle(color: Colors.white, fontSize: 18),
                      border: InputBorder.none,
                      // prefixIcon: Icon(Icons.search, color: Colors.white),
                      prefixIconColor: Colors.white,
                      focusColor: Colors.white,
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          _searchUser('');
                        },
                        color: Colors.white,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    onChanged: (text) {
                      _searchUser(text);
                    },
                  ),
                  centerTitle: true,
                ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _fetchUser();
            },
          ),
          !isLoading
              ? (_foundUsers.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) {
                          return ListTile(
                            title: Text(_foundUsers.elementAt(index).name),
                            leading: Text(
                              (index + 1).toString(),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(_foundUsers.elementAt(index).id);
                              },
                            ),
                          );
                        },
                        childCount: _foundUsers.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: const Center(
                          child: Text('Không tìm thấy dữ liệu'),
                        ),
                      ),
                    ))
              : SliverToBoxAdapter(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: const Center(child: CircularProgressIndicator())))
        ],
      ),
    );
  }
}
