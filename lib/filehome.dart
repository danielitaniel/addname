import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:addname/welcome.dart';
import 'package:addname/datasearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:addname/create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Constants {
  static const String new_file = "Upload New File";
  static const String new_folder = "Create a New Folder";

  static const List<String> choices = <String> [
    new_file,
    new_folder,
  ];
}


class FilePage extends StatefulWidget {
  //FilePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  static String title = "file_home_route";
  @override
  _filePage createState() => _filePage();
}

class _filePage extends State<FilePage> {
  // This widget is the root of your application.
  final _authentication = FirebaseAuth.instance;
  bool showSpinner = false;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _authentication.currentUser();
      if(user != null) {

      }
    } catch (exception) {
      //TO FIX
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
              leading: Icon(
                Icons.list,
              ),
              actions: [IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    showSpinner = true;
                  });
                  showSearch(context: context, delegate: DataSearch());
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    _authentication.signOut();
                    Navigator.pushNamed(context, WelcomePage.title);
                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),
              ],
              backgroundColor: Colors.orange,
              title: Text("Files")
          ),
          body: Stack(
            children: <Widget>[
              Positioned(
                bottom: 25,
                right: 25,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.orange,
                    size: 40.0,
                  ),
                  onPressed: () {
                    return showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actions:<Widget>[
                              Center(
                                child: FlatButton(
                                  child: Text(Constants.new_folder),
                                  onPressed: () {
                                    return showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("New Folder"),
                                          titleTextStyle: TextStyle(
                                            color: Colors.orange,
                                          ),
                                          content: TextField(
                                            cursorColor: Colors.orange,
                                            decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                          ),
                                          actions:<Widget>[
                                            Center(
                                              child: FlatButton(
                                                child: Text("Cancel"),
                                                textColor: Colors.orange,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Center(
                                              child: FlatButton(
                                                child: Text("Create"),
                                                textColor: Colors.orange,
                                                onPressed: () {

                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Center(
                                child: FlatButton(
                                  child: Text(Constants.new_file),
                                  onPressed: () {

                                  },
                                  //padding: EdgeInsets.symmetric(
                                    //horizontal: 72.0
                                  //),
                                ),
                              ),
                            ],
                          );
                        }
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    ),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _searchBar createState() => _searchBar();
}

class _searchBar extends State<SearchPage> {
  @override
  final searchField = TextField(
    obscureText: false,
    //style: style,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter file or folder name",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
    ),
  );

  Widget build(BuildContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            leading: Icon(
              Icons.list,
            ),
            actions: [IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
              Icon(null),
            ],
            backgroundColor: Colors.orange,
            title: Text("Files")
        ),
        body: SafeArea(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: searchField,
          ),
        ),
      ),
    );
  }
}



