//import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:addname/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:addname/filehome.dart';


class RegistrationScreen extends StatefulWidget{

  static const String title = "register_route";
  _RegistrationScreenState createState() => _RegistrationScreenState();

}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  //make authentication private!
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  Widget build(BuildContext context) {
//    final registerButton = Material(
//      elevation: 5.0,
//      borderRadius: BorderRadius.circular(30.0),
//      color: Colors.orange,
//      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
//        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//        onPressed: () {
////          Navigator.of(context).pushNamed('/filePage');
//        },
//        child: Text("Register",
//          textAlign: TextAlign.center,
//        ),
//
//      ),
//    );

    final emailField = TextField(
      textAlign: TextAlign.center,
      onChanged: (value) {
        email = value;
      },
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter your email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final passwordField = TextField(
      textAlign: TextAlign.center,
      onChanged: (value) {
        password = value;
      },
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter your password",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          try {
            final newUser = await _auth.createUserWithEmailAndPassword(
                email: email, password: password);
            if(newUser != null) {
              Navigator.pushNamed(context, WelcomePage.title);
            }
          } catch (exception) {
            //TO IMPLEMENT
            print(exception);
          }
        },
        child: Text("Register",
          textAlign: TextAlign.center,

        ),

      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pushNamed(context, WelcomePage.title);
            }
          ),
        ],
        title: Text('Register @AddName'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
          padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  registerButton,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}