import 'package:flutter/material.dart';
import 'package:addname/filehome.dart';

class WelcomePage extends StatefulWidget {
  //LogInPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  static String title = "login_route";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  //TextStyle style = TextStyle(fontFamily:  'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      obscureText: false,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "@ Handle",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final passwordField = TextField(
      obscureText: true,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pushNamed(context, FilePage.title);
        },
        child: Text("Login",
          textAlign: TextAlign.center,

        ),

      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
//          Navigator.of(context).pushNamed('/filePage');
        },
        child: Text("Register",
          textAlign: TextAlign.center,

        ),

      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset('images/atsignlogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
                registerButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//class _homePage extends StatefulWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: Scaffold(
//        body: Row(
//            //child: Image(
//              //image: AssetImage('images/poor.png'),
//
//            //)
//        ),
//        appBar: AppBar(
//
//          leading: Icon(
//            Icons.list,
//          ),
//          actions: [IconButton(
//            icon: Icon(Icons.search),
//            onPressed: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => _searchBar()),
//              );
//            },
//          ),
//            Icon(null),
//          ],
////            actions: [Stack(
////              children:[
////                Align(
////                  alignment: Alignment(0.0,0.0),
////                  child: Icon(
////                    Icons.search,
////                  ),
////                ),
////                Align()
////              ]
////            )],
//          backgroundColor: Colors.lightBlue,
//          title: Text("Files")
//      ),
//      ),
//    );
//
//}

//class _searchBar extends State<MyLogInPage> {
//  @override
//  Widget build(BuildContext) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: Scaffold(
//        appBar: AppBar(
//          leading: Icon(
//          Icons.list,
//          ),
//        actions: [IconButton(
//          icon: Icon(Icons.search),
//          onPressed: () {
//            Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => _homePage()),
//            );
//          },
//        ),
//          Icon(null),
//        ],
//        //            actions: [Stack(
//        //              children:[
//        //                Align(
//        //                  alignment: Alignment(0.0,0.0),
//        //                  child: Icon(
//        //                    Icons.search,
//        //                  ),
//        //                ),
//        //                Align()
//        //              ]
//        //            )],
//          backgroundColor: Colors.lightBlue,
//          title: Text("Files")
//          ),
//          ),
//            ),
//  }
//  @override
//  _LogInPageState createState() => _LogInPageState();
//}
//
//
//
