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

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: '@AddName File List UI',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has an orange toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.orange,
//        // This makes the visual density adapt to the platform that you run
//        // the app on. For desktop platforms, the controls will be smaller and
//        // closer together (more dense) than on mobile platforms.
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: MyLogInPage(title: '@AddName Demo Home Page'),
//    );
//  }
//}

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
  //final FocusNode _focusNode = FocusNode();

  void initState() {
    super.initState();
    getCurrentUser();
//    _focusNode.addListener(() {
//      if (_focusNode.hasFocus) {
//        this._overlayEntry = this._createOverlayEntry();
//        Overlay.of(context).insert(this._overlayEntry);
//      } else {
//        this._overlayEntry.remove();
//      }
//    });
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
//  @override
//  void dispose() {
//    // Clean up the focus node when the Form is disposed.
//    _focusNode.dispose();
//
//    super.dispose();
//  }
//
//
//  OverlayEntry _overlayEntry;
//
//  OverlayEntry _createOverlayEntry() {
//
//    RenderBox renderBox = context.findRenderObject();
//    var size = renderBox.size;
//    var offset = renderBox.localToGlobal(Offset.zero);
//
//    return OverlayEntry(
//        builder: (context) => Positioned(
//          left: offset.dx,
//          top: offset.dy + size.height + 5.0,
//          width: size.width,
//          child: Material(
//            elevation: 4.0,
//            child: ListView(
//              padding: EdgeInsets.zero,
//              shrinkWrap: true,
//              children: <Widget>[
//                ListTile(
//                  title: Text(Constants.new_file),
//                ),
//                ListTile(
//                  title: Text(Constants.new_folder),
//                ),
//              ],
//            ),
//          ),
//        )
//    );
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
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SearchPage()),
//                );
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
//            actions: [Stack(
//              children:[
//                Align(
//                  alignment: Alignment(0.0,0.0),
//                  child: Icon(
//                    Icons.search,
//                  ),
//                ),
//                Align()
//              ]
//            )],
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
                            //shape: CircleBorder(
                              //side: BorderSide(width: 32.0, color: Colors.white),
                            //),
                            //actionsPadding: EdgeInsets.all(55.0),
                            //buttonPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            actions:<Widget>[
                              Center(
                                child: FlatButton(
                                  //padding: EdgeInsets.symmetric(
                                      //horizontal: 62.0
                                  //),
                                  child: Text(Constants.new_folder),
                                  onPressed: () {
                                    return showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Enter Folder Name"),
                                          content: TextField(),
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
            //            actions: [Stack(
            //              children:[
            //                Align(
            //                  alignment: Alignment(0.0,0.0),
            //                  child: Icon(
            //                    Icons.search,
            //                  ),
            //                ),
            //                Align()
            //              ]
            //            )],
            backgroundColor: Colors.orange,
            title: Text("Files")
        ),
        body: SafeArea(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: searchField,
//              child: Padding(
//                padding: const EdgeInsets.all(36.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    //trying this out
//                    SizedBox(height: 45.0),
//                    searchField,
//                  //NEW CODE
////                  Stack(children: [
////                    Positioned(
////                      top: 25,
////                      left: 50,
////                      child: searchField,
////                    )
////                  ]),
//                  ],
//                ),
//              ),
            //),
          ),
        ),
      ),
    );
  }
}



