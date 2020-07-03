//import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:addname/welcome.dart';
import 'package:addname/datasearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:addname/create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:addname/filehome.dart';

class DataSearch extends StatefulWidget {
  //FilePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  var filenames = [];
  DataSearch(List<dynamic> usersFiles) {
    this.filenames = usersFiles;
  }

  static String title = "search_files_route";
  @override
  _dataSearch createState() => _dataSearch(this.filenames);
}

class _dataSearch extends State<DataSearch> {
  bool _visible = false;
  var recentFiles = [];

  final _authentication = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  bool showSpinner = false;
  var query = TextEditingController();
  var filenames = [];
  _dataSearch(List<dynamic> usersFiles) {
    this.filenames = usersFiles;
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _authentication.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (exception) {
      //TO FIX
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    query.addListener(() async{
      var inputLen = await query.text.length;
      if(inputLen == 0) {
        setState(() {
          _visible = false;
        });
      } else {
        print(query);
        setState(() {
          _visible = true;
        });
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
        //backgroundColor: Colors.white,
        //valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            title: TextField(
                controller: query,
                cursorColor: Colors.white,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
              ),
            ),
            actions: <Widget>[
              Opacity(
                opacity: _visible? 1.0 : 0.0,
                child: IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.white,
                  onPressed: () async {
                    bool userHasInput = await query.toString().length > 1;
                    if(userHasInput) {
                      query.clear();
                    }
                  },
                ),
              ),
            ],
          ),
          body: buildSuggestions(context),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var queryLen = query.text.toString().length;
    print(filenames);
    final suggestionList = queryLen <= 0
        ? recentFiles
        : filenames.where((str) => str.startsWith(query.text)).toList();
    if (suggestionList == recentFiles) {
      return ListTile(
        //leading: Icon(Icons.access_time),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            //text: suggestionList[index].substring(0, query.length),
            text: "Please enter an existing folder or file name.",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold
            ),
//                  children: [
//                    TextSpan(
//                      text: suggestionList[index].substring(query.length),
//                      style: TextStyle(color: Colors.grey),
//                    ),
//                  ]
          ),
        ),
      );
      //itemCount: suggestionList.length,
    } else if (suggestionList.isEmpty) {
      return ListTile(
        //leading: Icon(Icons.access_time),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            //text: suggestionList[index].substring(0, query.length),
              text: "No files found.",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              children: [
//                    TextSpan(
//                      text: suggestionList[index].substring(query.length),
//                      style: TextStyle(color: Colors.grey),
//                    ),
              ]
          ),
        ),
      );
      //itemCount: suggestionList.length,

    }else {
      return ListView.builder(itemBuilder: (context, index) =>
          ListTile(
            onTap: () {
            },
            leading: Icon(Icons.search),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.text.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.text.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ]
              ),
            ),
          ),
        itemCount: suggestionList.length,
      );

    }
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    query.dispose();
    super.dispose();
  }

}