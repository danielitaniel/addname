import 'package:addname/filehome.dart';
import 'package:flutter/material.dart';
import 'package:addname/welcome.dart';
import 'package:addname/registration.dart';
import 'package:addname/atsign_protocol_demo.dart';
import 'package:addname/create.dart';
//import 'package:addname/datasearch.dart';
import 'package:addname/filehome.dart';
//import 'package:addname/searchbar.dart';
//import 'file:///Users/danyitani/AndroidStudioProjects/addname/lib/filehome.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:addname/route_generator.dart';


//JULY 2nd 2020

//THIS IS MY LAST GIT COMMIT USING FIREBASE, FROM THIS POINT ONWARDS I AM MOVING TO DOCKER AND USING THE @ PROTOCOL


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '@AddName Login UI',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
        //Add routes for simplicity when moving from one page to another page.
        initialRoute: WelcomePage.title,
        routes: {
          WelcomePage.title: (context) => WelcomePage(),
          FilePage.title: (context) => FilePage(),
          RegistrationScreen.title: (context) => RegistrationScreen(),
          AtLookupWidget.title: (context) => AtLookupWidget(),

        }
    );
  }
}

