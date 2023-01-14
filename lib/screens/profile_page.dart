// ignore_for_file: prefer_const_constructors,prefer_const_literals_to_create_immutables

import 'package:chat_app_firebase/main.dart';
import 'package:chat_app_firebase/screens/auth/login_page.dart';
import 'package:chat_app_firebase/screens/home_page.dart';
import 'package:chat_app_firebase/services/auth_services.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:chat_app_firebase/widgets/widgets.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  const ProfilePage({super.key, required this.userName, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: Text(
            "Profile",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 50),
            children: [
              Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.grey[700],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.userName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 2,
                color: Colors.black45,
              ),
              ListTile(
                onTap: () {
                  nextScreenReplacement(context, HomePage());
                },
                selectedColor: primaryColor,
                selected: false,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(
                  Icons.group,
                ),
                title: Text(
                  "Groups",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {},
                selectedColor: primaryColor,
                selected: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(
                  Icons.person,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      await AuthService()
                                          .signout()
                                          .whenComplete(() {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()),
                                            (route) => false);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ))
                              ],
                            ),
                          ],
                        );
                      });
                },
                selectedColor: primaryColor,
                selected: false,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(
                  Icons.exit_to_app,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                size: 200,
                color: Colors.grey[700],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Full Names :",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    widget.userName,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email :",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
