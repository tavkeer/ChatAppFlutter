// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:chat_app_firebase/helper/helper_functions.dart';
import 'package:chat_app_firebase/screens/home_page.dart';
import 'package:chat_app_firebase/screens/login_page.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.grey[200]),
      debugShowCheckedModeBanner: false,
      home: (_isSignedIn) ? HomePage() : LoginPage(),
    );
  }
}
