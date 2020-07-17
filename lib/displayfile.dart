import 'dart:io';
import 'dart:ui';

import 'package:addname/models/fileschema.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class DisplayFilePage extends StatefulWidget {
  //FilePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  static String title = "display_file_route";

  File fileToDisplay;

  DisplayFilePage(File file){
    this.fileToDisplay = file;
  }

  @override
  _DisplayPage createState() => _DisplayPage(fileToDisplay);
}

class _DisplayPage extends State<DisplayFilePage> {
  // This widget is the root of your application.

  File _file;
  _DisplayPage(File file) {
    this._file = file;
  }
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

  //Future<File> get file => null;

  void initState(){
    super.initState();
    getCurrentUser();
    final region = "us-west-1";
    final bucketId = "add-name-proto1.0";
    final AwsS3Client s3client = AwsS3Client(
        region: region,
        host: "s3.$region.amazonaws.com",
        bucketId: bucketId,
        accessKey: "AKIAU26ZH36TSGZZ5HGQ",
        secretKey: "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"
    );


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
    return Container(
        child: Image.asset(_file.path),
    );
  }

}