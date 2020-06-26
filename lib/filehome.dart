import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:addname/welcome.dart';
import 'package:addname/datasearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:addname/create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _authentication.currentUser();
      if(user != null) {
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
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: _fireStore.collection('test').snapshots(),
                  builder: (context, snapshot){
                    if (snapshot.hasData) {
                      List<Widget> folderWidgets = [];
                      folderWidgets.add(
                        SizedBox(
                          height: 15.0,
                        ),
                      );
                      final folders = snapshot.data.documents;
                      for (var folder in folders) {
                        final folderName = folder.data["folderName"];
                        final folderWidget = Text(
                            '$folderName',
                            style: TextStyle(
                              fontSize: 15.0,
                        ),
                        );
                        folderWidgets.add(folderWidget);
                        folderWidgets.add(
                          SizedBox(
                            height: 20.0,
                          ),
                        );
                      };
                      if(folderWidgets.isEmpty) {
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
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                          folderWidgets,
                      );
                    } else {
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
                    }
                  },
                ),
//                SizedBox(
//                  height: 10.0,
//                ),
                Container(
                  child: Align(
                    heightFactor: 1.5,
                    alignment: Alignment(0.85, -0.85),
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
                                              actions:<Widget>[
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
                                                      print("new foldername is: " + newFolderName);
                                                      if((newFolderName == null) || (newFolderName == "")) {
                                                        print('no folder name');
                                                        setState(() {
                                                          return showDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            builder: (BuildContext context) {
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
                                                                      textColor: Colors.orange,
                                                                      onPressed: () {
                                                                        userInputHolder.clear();
                                                                        newFolderName = null;
                                                                        Navigator.pop(context);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        });
                                                      };
                                                      var owner = loggedInUser.email;
                                                      //DocumentReference folderName = _fireStore.collection('folders').document(owner+newFolderName);
                                                      //print(folderName.path);
                                                      var folderNameExists = false;
                                                      var folderNames = await _fireStore.collection('test').getDocuments();
                                                      for(var folderName in folderNames.documents) {
                                                        if(folderName.documentID == (owner + newFolderName)) {
                                                          folderNameExists = !folderNameExists;
                                                        }
                                                      }
                                                      if (folderNameExists) {
                                                        setState(() {
                                                          return showDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            builder: (BuildContext context) {
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
                                                                      textColor: Colors.orange,
                                                                      onPressed: () {
                                                                        userInputHolder.clear();
                                                                        newFolderName = null;
                                                                        Navigator.pop(context);
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
                                                            "folderName": newFolderName,
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
                                        userInputHolder.clear();
                                        newFolderName = null;
                                      },
                                      //padding: EdgeInsets.symmetric(
                                        //horizontal: 72.0
                                      //),
                                    ),
                                  ),
                                ],);
                              },
                            );
                          },
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
  deleteFolder(Function folderDeleted) async {
    await _fireStore.collection('files').document('test@gmail.comtest').delete();
    print('sucessfully deleted test file');
    await _fireStore.collection('files').document('test@gmail.com').delete();
    print('sucessfully deleted \'\' file');

  }
}

