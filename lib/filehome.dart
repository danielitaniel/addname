//import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:addname/models/fileschema.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:async/async.dart';
import 'package:addname/welcome.dart';
//import 'package:addname/datasearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:addname/create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:addname/searchbar.dart';
import 'package:at_client/at_client.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:build_runner/build_runner.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:aws_s3/aws_s3.dart';
import 'package:addname/displayfile.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:addname/policyhelper.dart';
import 'dart:convert';



class Constants {
  static const String new_file = "Upload New File";
  static const String new_folder = "Create a New Folder";

  static const List<String> choices = <String> [
    new_file,
    new_folder,
  ];
}

// ignore: must_be_immutable
class FilePage extends StatefulWidget {
  //FilePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  List dataInFolder;
  String currFolder;
  FilePage([List data, String folder]){
    dataInFolder = data;
    currFolder = folder;
  }


  static String title = "file_home_route";
  @override
  _filePage createState() => _filePage(dataInFolder, currFolder);
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
  List<Widget> _homeScreenWidgets = [];
  File _newEncFile;
  String uriPath; //Path to download URL from Firebase
  File _cachedFile;
  List dataInFolder;
  String currFolder;
  final _region = "us-west-1";
  static const String _bucketId = "add-name-proto1.0";
  static const _accessKeyID = "input access key"; //remove this before pushing to GitHub
  static const _secretKeyID = "input secret key"; //remove this before pushing to GitHub
  static const _s3Endpoint =
      "https://s3.console.aws.amazon.com/s3/buckets/add-name-proto1.0/?region=us-west-1&tab=overview";

  _filePage([List data, String folder]){
    dataInFolder = data;

    currFolder = folder;
  }


  //Future<File> get file => null;

  void initState(){
    super.initState();
    getCurrentUser();



    //AWS Build Client

    // Region is set up as US West (N. California)
    //This is used for receiving data from AWS S3

//    final appDocumentDirectory =
//        await getApplicationDocumentsDirectory();
//    Hive.init(appDocumentDirectory.path);
//    Hive.registerAdapter(FileSchemaAdapter());
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
              leading: IconButton(
                icon: Icon(
                  Icons.list,
                ),
                onPressed: () {
                  return showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        actions: <Widget>[
                          CupertinoDialogAction(
                            textStyle: TextStyle(
                              fontSize: 25.0,
                              color: Colors.orange,
                            ),
                            child: Center(
                              child: Text(
                                "View Files",
                                style: TextStyle(
                                  fontSize: 45.0
                                ),
                              ),
                            ),
                            onPressed: () {

                            },
                          ),
                          CupertinoDialogAction(
                            textStyle: TextStyle(
                              fontSize: 25.0,
                              color:  Colors.orange,
                            ),
                            child: Center(
                              child: Text(
                                "View Folders",
                                style: TextStyle(
                                    fontSize: 45.0
                                ),
                              ),
                            ),
                            onPressed: () {

                            },
                          ),
                        ],

                      );
                    },
                  );
                },
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
//                  FutureBuilder(
//                    future: Hive.openBox(loggedInUser.email+"data"),
//                    builder: (BuildContext context, AsyncSnapshot snapshot) {
//                      if(snapshot.connectionState == ConnectionState.done) {
//                        if(snapshot.hasError){
//                          return Text(snapshot.error.toString());
//                        }
//                        else{
//                          return Text("Hello");
//                        }
//                      } else {
//                        return Scaffold();
//                      }
//
//                    },
//                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection('test').snapshots(),
                    builder: (context, snapshot) {
                      //add loading screen here
                      if (snapshot.hasData) {
                        _homeScreenWidgets.add(
                          SizedBox(
                            height: 15.0,
                          ),
                        );
                        final files = snapshot.data.documents;
                        for (var file in files) {
                          try {
                            final dataName = file.data["name"];
                            final filePath = file.data["path"];
                            final isFolder = file.data["isFolder"];
                            final dataContained = file.data["dataContained"];

                            if (!folderAndFileNames.contains(dataName)) {
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
                                              folderAndFileNames.clear();
                                              if(dataInFolder == null) {
                                                Navigator.pushNamed(
                                                    context, FilePage.title);
                                              } else {
                                                Navigator.push(context, MaterialPageRoute(
                                                  builder: (context) => FilePage(dataInFolder, currFolder),
                                                ));
                                              }
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
//                                                            Navigator.pop(
//                                                                context);
                                                            setState(() {
                                                              showSpinner = true;
                                                            });
                                                            deleteData(
                                                                loggedInUser
                                                                    .email,
                                                                '$dataName', false).whenComplete(() =>
                                                                setState(() {
                                                                  showSpinner = false;
                                                                })
                                                            );
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
                              _homeScreenWidgets.add(folderWidget);
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
                                              print("DATA NAME IS $dataName");
                                              await downloadFile(dataName);
                                              print("finished downloading");
                                            }
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
                                                                true);
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
                              _homeScreenWidgets.add(fileWidget);
                            }
                          } catch (e) {
                            print("error");
                            print(e);
                          }
                          _homeScreenWidgets.add(
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
                          _homeScreenWidgets,
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
                                              setState(() {
                                                showSpinner = true;
                                              });
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
                                                                setState(() {
                                                                  showSpinner = false;
                                                                });
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
                                                                setState(() {
                                                                  showSpinner = true;
                                                                });
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
                                                Navigator.pop(context);
                                                //NEED THIS SECOND CALL. DON'T REMOVE
                                                Navigator.pop(context);
                                                _fireStore.collection(
                                                    'test')
                                                    .document(owner + "encrypted" +
                                                    newFolderName)
                                                    .setData({
                                                  "owner": owner,
                                                  "name": newFolderName,
                                                  "isFolder": true,
                                                  "dataContained": [],
                                                }).whenComplete(() => setState(() {
                                                  showSpinner = false;
                                                }));
                                                userInputHolder.clear();
                                                newFolderName = null;
                                                folderAndFileNames.clear();
                                                if(dataInFolder == null) {
                                                  Navigator.pushNamed(
                                                      context, FilePage.title);
                                                } else {
                                                  Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => FilePage(dataInFolder, currFolder),
                                                  ));
                                                }
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

                                                  //fileToUpload.createSync(recursive: false);

                                                  //FIRST CRYPT PACKAGE
//                                                  var key = encrypt.Key.fromUtf8("test key");
//                                                  final iv = encrypt.IV.fromLength(16); // initialization vector
//                                                  final encrypter = Encrypter(AES(key));
                                                  //var fileEncrypt = encrypter.en

                                                  //SECOND CRYPT PACKAGE
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
                                                    print(longStringame);
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
                                                                  onPressed: () async {
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

                                                  setState(() {
                                                    showSpinner = true;
                                                  });

                                                  var owner = loggedInUser.email;
                                                  var fileNameExists = false;
                                                  var fileNames = await _fireStore
                                                      .collection('test')
                                                      .getDocuments();

                                                  //THIS IS NOT EFFICIENT. NEED TO RE-WRITE
                                                  //CHANGE LIST TO A DICTIONARY/HASH SET
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
                                                    var crypt = AesCrypt();
                                                    String encryptedFilePath;
                                                    crypt.setOverwriteMode(AesCryptOwMode.rename);

                                                    //CHANGE PASSWORD TO BE BETTER
                                                    crypt.setPassword('my cool password');
                                                    print("File To Upload Path ${fileToUpload.path}");
                                                    //create new encrypted file
                                                    Directory tempDir = await getTemporaryDirectory();
                                                    _newEncFile = await new File("${tempDir.path}/"+loggedInUser.email+newFileName+'.aes').create(recursive: true);
                                                    try {
                                                      // Encrypts user file and save encrypted file to a file with
                                                      // '.aes' extension added.
                                                      //allows for over-write. make sure I really want this
                                                      crypt.setOverwriteMode(AesCryptOwMode.rename);
                                                      print("encrypting file");
                                                      encryptedFilePath = crypt.encryptFileSync(fileToUpload.path, _newEncFile.path);
                                                      print("ENCRYPTEDFILE: $encryptedFilePath");
                                                    } on AesCryptException catch (e) {
                                                      // It goes here if overwrite mode set as 'AesCryptFnMode.warn'
                                                      // and encrypted file already exists.
                                                      if (e.type == AesCryptExceptionType.destFileExists) {
                                                        print('The file encryption has been completed unsuccessfully.');
                                                        print(e.message);
                                                      }
                                                    }
                                                    try {
                                                      final RegExp regExp = RegExp('[^?/]*\.(aes)');
                                                      final String encryptedFileName = regExp.stringMatch(encryptedFilePath);
                                                      print("ENCRYPTED FILE NAME: $encryptedFileName");
                                                      uploadFile(encryptedFilePath, "encrypted"+encryptedFileName, newFileName);
                                                      print("SUCCESS!!!");
                                                    } catch(e) {
                                                      print("error is before upload");
                                                      userInputHolder.clear();
                                                      newFileName = null;
                                                      fileToUpload = null;
                                                      setState(() {
                                                        showSpinner = false;
                                                      });
                                                      print(e);
                                                    }


                                                    //fileToUpload.deleteSync();

                                                    userInputHolder.clear();
                                                    newFileName = null;
                                                    fileToUpload = null;
                                                    setState(() {
                                                      showSpinner = false;
                                                    });
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


  Future<Null> uploadFile(String filepath, String fileName, String userInputName) async {
    try {

      //Create a temporary directory and file
      print("in uploadFIle");
      WidgetsFlutterBinding.ensureInitialized();
      final ByteData bytes = await rootBundle.load(filepath);
      final Directory tempDir = Directory.systemTemp;
      final file = File("${tempDir.path}/$fileName");
      file.writeAsBytes(bytes.buffer.asInt8List(),
          mode: FileMode.write); //FIX ME, WRITE? OR READ?
      print("temp file created");
      //HIVE UPLOAD
      //Upload file to secondary server (hive)
//      final filesBox = Hive.box(loggedInUser.email+"data");
//      filesBox.put(loggedInUser.email+fileName, file);

      //This is the DB Schema to be added to Hive in order to list all folder and file names
//      var fileSchema = new FileSchema(
//        loggedInUser.email,
//        fileName,
//        false,
//        [],
//      );
//      filesBox.add(fileSchema);

      //OLD FIREBASE CODE

//      print("about to upload");
//      final StorageReference ref = FirebaseStorage.instance.ref().child("encrypted" + userInputName);
//      print("upload file path is: $filepath");
//      final StorageUploadTask task = ref.putFile(file);
//      final Uri downloadUrl = (await task.onComplete).uploadSessionUri; // make sure this is correct
//      uriPath = downloadUrl.toString();
//      await _fireStore
//          .collection(
//          'test')
//          .document(loggedInUser.email +
//          "encrypted" +
//          userInputName)
//          .setData({
//        "owner": loggedInUser.email,
//        "name": userInputName,
//        "path": file.path,
//        "isFolder": false,
//        "url": uriPath,
//      });
//      print("ALL G");
      //tempDir.deleteSync(recursive: true);
      //folderAndFileNames.clear();

      //AWS code

      final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      final int length = await file.length();

      print("Length is $length");

      print("byte stream success");

      final uri = Uri.parse(_s3Endpoint);
      final req = http.MultipartRequest("POST", uri);
      final multipartFile = http.MultipartFile("file", stream, length, filename: userInputName);
      print("multi-part good");
      final policy = Policy.fromS3PreSignedPost("file/"+userInputName, _bucketId, _accessKeyID, 1, length, region: _region);
      print("policy good");
      final key =
      SigV4.calculateSigningKey(_secretKeyID, policy.datetime, _region, 's3');
      final signature = SigV4.calculateSignature(key, policy.encode());
      print("all good till req part");
      req.files.add(multipartFile);
      req.fields['key'] = policy.key;
      req.fields['acl'] = 'public-read';
      req.fields['X-Amz-Credential'] = policy.credential;
      req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
      req.fields['X-Amz-Date'] = policy.datetime;
      req.fields['Policy'] = policy.encode();
      req.fields['X-Amz-Signature'] = signature;
      print("all good before try");
      try {
        final res = await req.send();
        print("res good");
        await for (var value in res.stream.transform(utf8.decoder)) {
          print(value);
        }
      } catch (e) {
        print(e.toString());
      }

      if(dataInFolder == null) {
        Navigator.pushNamed(
            context, FilePage.title);
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FilePage(dataInFolder, currFolder),
        ));
      }

      tempDir.deleteSync(recursive: true);
      folderAndFileNames.clear();

    } catch (e) {
      print(e.toString());
    }
  }

  Future<Null> downloadFile(String fileName) async {

    var crypt = AesCrypt();
    String decFilepath;
    crypt.setOverwriteMode(AesCryptOwMode.rename);
    crypt.setPassword('my cool password');


    try {
      //print("httpPath $httpPath");
      //final RegExp regExp = RegExp('[^?/]*\.(aes)');
      //final String fileName = regExp.stringMatch(httpPath);
      //print(fileName);
      final Directory tempDir = Directory.systemTemp;
      final encFile = await File("${tempDir.path}/todecrypt$fileName").create(
          recursive: true);

      print(await encFile.length());
      print("FILE NAME IS $fileName");
      final dbReference = FirebaseStorage.instance.ref().child("encrypted" + fileName);
      print("All G");
      final StorageFileDownloadTask downloadTask = dbReference.writeToFile(
          encFile);

      //wait for upload task to finish
      final int byteNumber = (await downloadTask.future).totalByteCount;


      print("byte count is $byteNumber");

      final file = await File('${tempDir.path}/decryptedfile').create(
          recursive: true);
      print("good till here");

      decFilepath = crypt.decryptFileSync(encFile.path);

      print("decrypted?");

      final ByteData bytes = await rootBundle.load(decFilepath);
      print("loaded bytes");
      file.writeAsBytes(bytes.buffer.asInt8List(),
          mode: FileMode.write).whenComplete(() =>
          setState(() {
            _cachedFile = file;
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => DisplayFilePage(file)));
            print("CASHED FILE LENGTH ${_cachedFile.lengthSync()}");
          })
      ); //FIX ME, WRITE? OR READ?


//      folderAndFileNames.clear();
//      Navigator.pushNamed(context, FilePage.title);
    } catch(e) {
      print("error is here");
      print(e);
      if(dataInFolder == null) {
        Navigator.pushNamed(
            context, FilePage.title);
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FilePage(dataInFolder, currFolder),
        ));
      }
//      if (e.runtimeType == AesCryptException) {
//        return showDialog(
//            context: context,
//            barrierDismissible: true,
//            builder: (
//                BuildContext context) {
//              return AlertDialog(
//                title: RichText(
//                  text: TextSpan(
//                    children: [
//                      TextSpan(
//                        text: "This File Has Already Been Downloaded",
//                        style: TextStyle(
//                          fontSize: 20.0,
//                          color: Colors
//                              .black,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                content: RichText(
//                  text: TextSpan(
//                    children: [
//                      TextSpan(
//                        text: "Would you like to over-write file?",
//                        style: TextStyle(
//                          fontSize: 20.0,
//                          color: Colors
//                              .black,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                    child: Text("No"),
//                    onPressed: () {
//                      Navigator.pop(
//                          context);
//                    },
//                  ),
//                  FlatButton(
//                    child: Text("Yes"),
//                    onPressed: (){
//                      crypt.setOverwriteMode(AesCryptOwMode.rename);
//                    },
//                  ),
//                ],
//              );
//            }
//        );
//      }
    }

    //HIVE DOWNLOAD

    //final filesBox = Hive.box(loggedInUser.email+"data");


//    FutureBuilder(
//        future: dbReference.once(),
//        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
//          print('here');
//          if (snapshot.hasData) {
//            Map<dynamic, dynamic> values = snapshot.data.value;
//            values.forEach((key, values) {
//              print(key);
//            });
//          }
//          return Container(
//            color: Colors.black,
//            width: 150.0,
//            height: 150.0,
//            child: _cachedFile != null
//                ? Image.asset(
//                _cachedFile.path) 
//                : Container(),
//          );
//        }
//        );


//    final StorageReference ref = FirebaseStorage.instance.ref().child(httpPath);
//    print("ref is good.");
//    print(ref.path);
//    final StorageFileDownloadTask downloadTask = ref.writeToFile(encFile);
//
//    //wait for upload task to finish
//    final int byteNumber = (await downloadTask.future).totalByteCount;
//
//    print("byte number is $byteNumber" );
//    final file = await File('${tempDir.path}/decryptedfile').create(recursive: true);
//    print("good till here");
//
//    decFilepath = crypt.decryptFileSync(encFile.path);
//
//    print("decrypted?");
//
//    final ByteData bytes = await rootBundle.load(decFilepath);
//    file.writeAsBytes(bytes.buffer.asInt8List(),
//        mode: FileMode.write); //FIX ME, WRITE? OR READ?
//
//
//
//    setState(() {
//      _cachedFile = file;
//    });

  }

//  void dispose() {
//    Hive.box(loggedInUser.email+"data").close();
//    super.dispose();
//  }

//  ListView _buildListView() {
//    final filesBox = Hive.box(loggedInUser.email + "data");
//    return ListView.builder(
//      itemCount: filesBox.length,
//      itemBuilder: (context, index) {
//        return ListTile(
//        );
//      },
//    );
//  }



  Future<Null> deleteData(String ownerEmail, String folderFileName, bool isFile) async {
//    await _fireStore.collection('test')
//        .document(ownerEmail + folderFileName)
//        .delete();
    await _fireStore.collection('test')
        .document(ownerEmail + "encrypted" + folderFileName)
        .delete();
    if (isFile) {
      await _fireStorage.ref().child("encrypted" + folderFileName).delete();
    }
    folderAndFileNames.remove(folderFileName);
    folderAndFileNames.clear();
    if(dataInFolder == null) {
      Navigator.pushNamed(
          context, FilePage.title);
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => FilePage(dataInFolder, currFolder),
      ));
    }
  }
}

