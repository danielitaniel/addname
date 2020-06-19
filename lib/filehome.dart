import 'package:flutter/material.dart';
import 'package:addname/welcome.dart';
import 'package:addname/datasearch.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: Scaffold(
        appBar: AppBar(
            leading: Icon(
              Icons.list,
            ),
            actions: [IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SearchPage()),
//                );
              },
            ),
              IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  _authentication.signOut();
                  Navigator.pushNamed(context, WelcomePage.title);
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



