import 'package:flutter/material.dart';
import 'package:sqflite_dog/model/base_entity.dart';
import 'package:sqflite_dog/model/user.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<User> usersList = [];
  List<User> searchList = [];

  onload(BuildContext context) async {
    var lists = await BaseEntity<User>().getAll();
    for (var item in lists) {
      var todoItem = User.fromMap(item);
      usersList.add(todoItem);
    }

    (context as Element).markNeedsBuild();
  }

  onSearch(BuildContext context) async {
    // _searchList.clear();
    var lists = await BaseEntity<User>().search(query, 'name', 'name_eng');
    for (var item in lists) {
      var todoItem = User.fromMap(item);
      searchList.add(todoItem);
    }
    (context as Element).markNeedsBuild();
  }

  @override
  String get searchFieldLabel => 'Tìm Kiếm';
  @override
  TextInputType get keyboardType => TextInputType.name;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // searchList = DBHelper.searchDogs(query);
    searchList.clear();

    // var items = BaseEntity<User>().search(query, 'name', 'name_eng');
    onSearch(context);

    return Column(
      children: <Widget>[
        searchList.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        searchList.elementAt(index).name,
                      ),
                      leading: Text(
                        (index + 1).toString(),
                      ),
                    );
                  },
                  itemCount: searchList.length,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(child: CircularProgressIndicator()),
                ],
              )
        // FutureBuilder<List>(
        //   future: items,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return snapshot.data!.isNotEmpty
        //           ? Expanded(
        //               child: ListView.builder(
        //                 itemBuilder: (context, index) {
        //                   User user = User(
        //                     snapshot.data!.elementAt(index)['id'],
        //                     snapshot.data!.elementAt(index)['name'],
        //                     snapshot.data!.elementAt(index)['name_eng'],
        //                     snapshot.data!.elementAt(index)['age'],
        //                   );
        //                   return ListTile(
        //                     title: Text(
        //                       user.name,
        //                     ),
        //                     leading: Text(
        //                       (index + 1).toString(),
        //                     ),
        //                   );
        //                 },
        //                 itemCount: snapshot.data!.length,
        //               ),
        //             )
        //           : const Center(child: Text('No data found'));
        //     } else if (snapshot.hasError) {
        //       return Text('${snapshot.error}');
        //     }
        //     // By default, show a loading spinner.
        //     return const Text('No data');
        //   },
        // )
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      hintColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // onLoad();
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    onload(context);
    return Column(
      children: [
        usersList.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        usersList.elementAt(index).name,
                      ),
                      leading: Text(
                        (index + 1).toString(),
                      ),
                    );
                  },
                  itemCount: usersList.length,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(child: CircularProgressIndicator()),
                ],
              )
        // FutureBuilder<List>(
        //   future: items,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return snapshot.data!.isNotEmpty
        //           ? Expanded(
        //               child: ListView.builder(
        //                 itemBuilder: (context, index) {
        //                   User user = User(
        //                     snapshot.data!.elementAt(index)['id'],
        //                     snapshot.data!.elementAt(index)['name'],
        //                     snapshot.data!.elementAt(index)['name_eng'],
        //                     snapshot.data!.elementAt(index)['age'],
        //                   );
        //                   return ListTile(
        //                     title: Text(
        //                       user.name,
        //                     ),
        //                     leading: Text(
        //                       (index + 1).toString(),
        //                     ),
        //                   );
        //                 },
        //                 itemCount: snapshot.data!.length,
        //               ),
        //             )
        //           : const Center(child: Text('No data found'));
        //     } else if (snapshot.hasError) {
        //       return Text('${snapshot.error}');
        //     }
        //     // By default, show a loading spinner.
        //     return const Text('No data');
        //   },
        // )
      ],
    );
  }
}
