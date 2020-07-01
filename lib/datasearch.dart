import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:ui';


class DataSearch extends SearchDelegate<String> {
  var fileNames = [];
  var recentFiles = [];
  DataSearch(List<dynamic> fileNames){
    this.fileNames = fileNames;
  }
  static const String title = "data_search_home";
  //final cities = ["Beirut", "Tripoli", "Tyre", "Sidon", "Byblos", "Jounieh"];
  //final recentCities = []; // come back to this
  final _authentication = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final _fireStore = Firestore.instance;
  //bool showSpinner = false;
  var userInputHolder = TextEditingController();
  String newFolderName;
  String newFileName;
  File fileToUpload;
  var isLoading = false;

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

  //var _controller = TextEditingController();
  //String result  = "";
  @override

  //ACTIONS FOR APP BAR
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          },
      ),
    ];
  }

  //LEFT OF APP BAR ICON: EXITS SEARCH
  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      }
      );
  }

  /*SHOW RESULTS BASED ON USER REQUEST AFTER FILE/FOLDER IS CLICKED IN SEARCH BAR
   * WILL NEED TO MAKE THIS REDIRECT/OPEN THE FILE/FOLDER
   */
  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Card (
          color: Colors.orange,
          //shape: StadiumBorder(),
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );

  }


  //REAL TIME SUGGESTIONS AS SOON AS USER BEGINGS TYPING
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentFiles
        : fileNames.where((str) => str.startsWith(query)).toList();
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
                showResults(context);
              },
              leading: Icon(Icons.search),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: suggestionList[index].substring(query.length),
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
  
}