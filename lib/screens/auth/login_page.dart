// ignore_for_file: prefer_const_constructors,prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:math';

import 'package:chat_app_firebase/helper/helper_functions.dart';
import 'package:chat_app_firebase/screens/auth/register_page.dart';
import 'package:chat_app_firebase/screens/home_page.dart';
import 'package:chat_app_firebase/services/auth_services.dart';
import 'package:chat_app_firebase/services/database_services.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:chat_app_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  //hide/unhide password
  bool hidePassword = true;

  //change view password color
  Color hidePasswordColor = Colors.grey;

  //form key
  final formkey = GlobalKey<FormState>();

  String email = "";

  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (isLoading)
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: primaryColor,
                  color: Colors.grey,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Groupie",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Login now to see what they are talking",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Image.asset("assets/login.png"),

                          //email field
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                            decoration: textinputdecoration.copyWith(
                                label: Text(
                                  "Email",
                                  style: TextStyle(),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: primaryColor,
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          //password field
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            validator: (value) {
                              if (value!.length < 6) {
                                return "Password must be at least 6 char long";
                              } else {
                                return null;
                              }
                            },
                            obscureText: hidePassword,
                            decoration: textinputdecoration.copyWith(
                                label: Text(
                                  "Password",
                                  style: TextStyle(),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: hidePasswordColor,
                                  ),
                                  onPressed: () {
                                    //print(emailController.text.toString());
                                    setState(() {
                                      hidePassword = !hidePassword;
                                      hidePasswordColor =
                                          (hidePasswordColor == Colors.grey)
                                              ? primaryColor
                                              : Colors.grey;
                                    });
                                  },
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      backgroundColor: primaryColor),
                                  onPressed: () {
                                    login();
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ))),
                          SizedBox(
                            height: 15,
                          ),
                          Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Register Here!',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, RegisterPage());
                                      })
                              ],
                              text: "Don't have an account?",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          )
                        ],
                      )),
                ),
              ));
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await AuthService()
          .loggInWithUserNameAndPassord(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseServices(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);

          //saving the value to our shared preferences

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplacement(context, HomePage());
        } else {
          showSnackBar(context, Colors.red.shade400, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
