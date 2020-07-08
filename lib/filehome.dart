//import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:addname/welcome.dart';
//import 'package:addname/datasearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:addname/create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:addname/searchbar.dart';
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
  FirebaseUser loggedInUser;
  final _fireStorage = FirebaseStorage.instance;
  final _fireStore = Firestore.instance;
  bool showSpinner = false;
  var userInputHolder = TextEditingController();
  String newFolderName;
  String newFileName;
  File fileToUpload;
  var folderAndFileNames = [];

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
              leading: Icon(
                Icons.list,
              ),
              actions: [IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  //await showSearch(context: context, delegate: DataSearch(folderAndFileNames));
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DataSearch(folderAndFileNames),
                  ));
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    _authentication.signOut();
                    await Navigator.pushNamed(context, WelcomePage.title);
                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),
              ],
              backgroundColor: Colors.orange,
              title: Text("Files")
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection('test').snapshots(),
                    builder: (context, snapshot) {
                      //add loading screen here
                      List<Widget> homeScreenWidgets = [];
                      if (snapshot.hasData) {
                        homeScreenWidgets.add(
                          SizedBox(
                            height: 15.0,
                          ),
                        );
                        final files = snapshot.data.documents;
                        for (var file in files) {
                          final dataName = file.data["name"];
                          final filePath = file.data["path"];
                          final isFolder = file.data["isFolder"];
                          if(!folderAndFileNames.contains(dataName)) {
                            folderAndFileNames.add(dataName);
                          }
                          if (isFolder) {
                            final folderWidget = Stack(
                              children: <Widget>[
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                        child: Icon(
                                          Icons.folder,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 5,
                                      child: Container(
                                        child: FlatButton(
                                          child: Text(
                                            '$dataName',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                            textAlign: TextAlign.justify,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          onPressed: () async {
//                                            String cloudBucket = await _fireStorage.ref().child(filePath).getBucket();
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.orange,
                                          ),
                                          onPressed: () {

                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.orange,
                                          ),
                                          onPressed: () {
                                            return showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (
                                                    BuildContext context) {
                                                  return AlertDialog(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "Are you sure you want to delete the folder ",
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: dataName,
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .black,
                                                              fontStyle: FontStyle
                                                                  .italic,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "?",
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text("No"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text("Yes"),
                                                        onPressed: () {
                                                          deleteData(
                                                              loggedInUser
                                                                  .email,
                                                              '$dataName');
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                }
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                  ],
                                ),
                              ],
                            );
                            homeScreenWidgets.add(folderWidget);
                          } else {
                            final fileWidget = Stack(
                              children: <Widget>[
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                        child: Icon(
                                          Icons.chrome_reader_mode,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 5,
                                      child: Container(
                                        child: FlatButton(
                                          child: Text(
                                            '$dataName',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                            textAlign: TextAlign.justify,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          onPressed: () async {
//                                            List cloudBucket = await _fireStorage
//                                                .ref().child(filePath).getData(
//                                                1);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.orange,
                                          ),
                                          onPressed: () {

                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.orange,
                                          ),
                                          onPressed: () {
                                            return showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (
                                                    BuildContext context) {
                                                  return AlertDialog(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "Are you sure you want to delete the file ",
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: dataName,
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .black,
                                                              fontStyle: FontStyle
                                                                  .italic,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "?",
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text("No"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text("Yes"),
                                                        onPressed: () {
                                                          deleteData(
                                                              loggedInUser
                                                                  .email,
                                                              '$dataName',
                                                              filePath);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                }
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                  ],
                                ),
                              ],
                            );
                            homeScreenWidgets.add(fileWidget);
                          }
                          homeScreenWidgets.add(
                            SizedBox(
                              height: 20.0,
                            ),
                          );
                        }
                      }
                      if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "You Have No Files",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          homeScreenWidgets,
                        );
                      }
                    },
                  ),
//                SizedBox(
//                  height: 10.0,
//                ),
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            height: 45.0,
            width: 45.0,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.add,
                  size: 35.0,
                ),
//            child: Icon(
//              Icons.add_circle,
//              //color: Colors.orange,
//              size: 40.0,
//            ),
                onPressed: () {
                  return showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: <Widget>[
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
                                          controller: userInputHolder,
                                          cursorColor: Colors.orange,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            newFolderName = value;
                                          }
                                      ),
                                      actions: <Widget>[
                                        Center(
                                          child: FlatButton(
                                            child: Text("Cancel"),
                                            textColor: Colors.orange,
                                            onPressed: () {
                                              userInputHolder.clear();
                                              newFolderName = null;
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Center(
                                          child: FlatButton(
                                            child: Text("Create"),
                                            textColor: Colors.orange,
                                            onPressed: () async {
                                              //User must create folder name
                                              if ((newFolderName == null) || (newFolderName == "")) {
                                                setState(() {
                                                  return showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (
                                                        BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Folder name required"
                                                        ),
                                                        titleTextStyle: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 20.0,
                                                        ),
                                                        actions: <Widget>[
                                                          Center(
                                                            child: FlatButton(
                                                              child: Text(
                                                                  "Ok"
                                                              ),
                                                              textColor: Colors
                                                                  .orange,
                                                              onPressed: () {
                                                                userInputHolder
                                                                    .clear();
                                                                newFolderName =
                                                                null;
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                              }
                                              var owner = loggedInUser.email;
                                              var folderNameExists = false;
                                              var dataStorage = await _fireStore.collection('test').getDocuments();
                                              for (var folderName in dataStorage
                                                  .documents) {
                                                if (folderName.documentID ==
                                                    (owner + newFolderName)) {
                                                  folderNameExists =
                                                  !folderNameExists;
                                                }
                                              }
                                              if (folderNameExists) {
                                                setState(() {
                                                  return showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (
                                                        BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Folder Name Already Exists"
                                                        ),
                                                        titleTextStyle: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 20.0,
                                                        ),
                                                        actions: <Widget>[
                                                          Center(
                                                            child: FlatButton(
                                                              child: Text(
                                                                  "Ok"
                                                              ),
                                                              textColor: Colors
                                                                  .orange,
                                                              onPressed: () {
                                                                userInputHolder
                                                                    .clear();
                                                                newFolderName =
                                                                null;
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                              } else {
                                                //BUILD ENCRYPTION ALGORITHM BEFORE STORING.
                                                _fireStore.collection(
                                                    'test')
                                                    .document(owner +
                                                    newFolderName)
                                                    .setData({
                                                  "owner": owner,
                                                  "name": newFolderName,
                                                  "isFolder": true,
                                                });
                                                userInputHolder.clear();
                                                newFolderName = null;
                                                Navigator.pop(context);
                                                //NEED THIS SECOND CALL. DON'T REMOVE
                                                Navigator.pop(context);
                                              }
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
                                return showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("New File(s)"),
                                      titleTextStyle: TextStyle(
                                        color: Colors.orange,
                                      ),
                                      content: TextField(
                                          controller: userInputHolder,
                                          cursorColor: Colors.orange,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            newFileName = value;
                                          }
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            Center(
                                              child: FlatButton(
                                                child: Text("Cancel"),
                                                textColor: Colors.orange,
                                                onPressed: () {
                                                  userInputHolder.clear();
                                                  newFileName = null;
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Center(
                                              child: FlatButton(
                                                child: Text("Upload"),
                                                textColor: Colors.orange,
                                                onPressed: () async {
                                                  fileToUpload =
                                                  await FilePicker.getFile(
                                                      type: FileType.any);
                                                  if (fileToUpload == null) {
                                                    setState(() {
                                                      return showDialog(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        builder: (
                                                            BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "File Required"
                                                            ),
                                                            titleTextStyle: TextStyle(
                                                              color: Colors
                                                                  .orange,
                                                              fontSize: 20.0,
                                                            ),
                                                            actions: <Widget>[
                                                              Center(
                                                                child: FlatButton(
                                                                  child: Text(
                                                                      "Ok"
                                                                  ),
                                                                  textColor: Colors
                                                                      .orange,
                                                                  onPressed: () {
                                                                    userInputHolder
                                                                        .clear();
                                                                    newFileName =
                                                                    null;
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    });
                                                  } else {
                                                    var longStringame = fileToUpload.toString();
                                                    newFileName = longStringame.substring(longStringame.lastIndexOf("/" ) +1, longStringame.length-1);
                                                    userInputHolder.text = newFileName;
                                                  }
                                                },
                                              ),
                                            ),
                                            Center(
                                              child: FlatButton(
                                                child: Text("Create"),
                                                textColor: Colors.orange,
                                                onPressed: () async {
                                                  if (TextInputType.text ==
                                                      null) {
                                                    setState(() {
                                                      return showDialog(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        builder: (
                                                            BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "File Name Required"
                                                            ),
                                                            titleTextStyle: TextStyle(
                                                              color: Colors
                                                                  .orange,
                                                              fontSize: 20.0,
                                                            ),
                                                            actions: <Widget>[
                                                              Center(
                                                                child: FlatButton(
                                                                  child: Text(
                                                                      "Ok"
                                                                  ),
                                                                  textColor: Colors
                                                                      .orange,
                                                                  onPressed: () {
                                                                    userInputHolder
                                                                        .clear();
                                                                    newFileName =
                                                                    null;
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                  //NEED THIS SECOND CALL. DON'T REMOVE
                                                  Navigator.pop(context);
                                                  //User must create file name
                                                  if ((newFileName == null) ||
                                                      (newFileName == "")) {
                                                    setState(() {
                                                      return showDialog(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        builder: (
                                                            BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "File name required"
                                                            ),
                                                            titleTextStyle: TextStyle(
                                                              color: Colors
                                                                  .orange,
                                                              fontSize: 20.0,
                                                            ),
                                                            actions: <Widget>[
                                                              Center(
                                                                child: FlatButton(
                                                                  child: Text(
                                                                      "Ok"
                                                                  ),
                                                                  textColor: Colors
                                                                      .orange,
                                                                  onPressed: () {
                                                                    userInputHolder
                                                                        .clear();
                                                                    newFileName =
                                                                    null;
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    });
                                                  }

                                                  var owner = loggedInUser.email;
                                                  var fileNameExists = false;
                                                  var fileNames = await _fireStore
                                                      .collection('test')
                                                      .getDocuments();

                                                  //THIS IS NOT EFFICIENT. NEED TO RE-WRITE
                                                  for (var fileName in fileNames
                                                      .documents) {
                                                    if (fileName.documentID ==
                                                        (owner + newFileName)) {
                                                      fileNameExists =
                                                      !fileNameExists;
                                                    }
                                                  }
                                                  if (fileNameExists) {
                                                    setState(() {
                                                      return showDialog(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        builder: (
                                                            BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "File Name Already Exists"
                                                            ),
                                                            titleTextStyle: TextStyle(
                                                              color: Colors
                                                                  .orange,
                                                              fontSize: 20.0,
                                                            ),
                                                            actions: <Widget>[
                                                              Center(
                                                                child: FlatButton(
                                                                  child: Text(
                                                                      "Ok"
                                                                  ),
                                                                  textColor: Colors
                                                                      .orange,
                                                                  onPressed: () {
                                                                    userInputHolder
                                                                        .clear();
                                                                    newFileName =
                                                                    null;
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showSpinner = true;
                                                    });

                                                    StorageUploadTask uploadTask = await _fireStorage
                                                        .ref()
                                                        .child(
                                                        fileToUpload.path)
                                                        .putFile(fileToUpload);

                                                    StorageTaskSnapshot snapshot = await uploadTask
                                                        .onComplete;


                                                    if (snapshot.error == null) {
                                                      final String downloadUrl = await snapshot.ref.getDownloadURL();

                                                      await _fireStore.collection(
                                                          'test')
                                                          .document(owner +
                                                          newFileName)
                                                          .setData({
                                                        "owner": owner,
                                                        "name": newFileName,
                                                        "path": fileToUpload.path,
                                                        "isFolder": false,
                                                        "url": downloadUrl,
                                                      });

                                                      setState(() {
                                                        showSpinner = false;
                                                        //isLoading = false;
                                                      });


                                                    } else {
                                                      throw ('Error uploading the file!');
                                                    }


                                                    //BUILD ENCRYPTION ALGORITHM BEFORE STORING.


                                                    fileToUpload.deleteSync();

                                                    userInputHolder.clear();
                                                    newFileName = null;
                                                    fileToUpload = null;
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteData(String ownerEmail, String folderName, [String path]) async {
    await _fireStore.collection('test')
        .document(ownerEmail + folderName)
        .delete();
    if (path != null) {
      await _fireStorage.ref().child(path).delete();
    }
  }
}

