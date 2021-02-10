import 'package:cab_rider/screens/loginpage.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/screens/registrationpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:297855924061:ios:c6de2b69b03a5be8',
      apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
      projectId: 'flutter-firebase-plugins',
      messagingSenderId: '297855924061',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:250754696730:android:f535efb677a19747ddf3a3',
      apiKey: 'AIzaSyDEXAnF70OJCrEukS1nS3oTZ_bfIPi37vg',
      messagingSenderId: '297855924061',
      projectId: 'greentaxi-9d858',
      databaseURL: 'https://greentaxi-9d858-default-rtdb.firebaseio.com',
    ),
  );
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone',
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
      ),
      initialRoute: RegistrationPage.id,
      routes:{
        RegistrationPage.id:(context) =>RegistrationPage(),
        LoginPage.id:(context) =>LoginPage(),
        MainPage.id :(context)=> MainPage()
      }
    );
  }
}

