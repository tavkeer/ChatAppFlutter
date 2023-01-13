// ignore_for_file: prefer_const_constructors

import 'package:chat_app_firebase/screens/auth/login_page.dart';
import 'package:chat_app_firebase/services/auth_services.dart';
import 'package:chat_app_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text("logout"),
        onPressed: () {
          authService.signout();
          nextScreenReplacement(context, LoginPage());
        },
      )),
    );
  }
}
