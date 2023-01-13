// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:chat_app_firebase/helper/helper_functions.dart';
import 'package:chat_app_firebase/screens/auth/login_page.dart';
import 'package:chat_app_firebase/screens/home_page.dart';
import 'package:chat_app_firebase/services/auth_services.dart';
import 'package:chat_app_firebase/shared/constants.dart';
import 'package:chat_app_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  bool hidePassword = true;
  Color hidePasswordColor = Colors.grey;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(backgroundColor: primaryColor))
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
                          "Create your account to chat and explore!",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Image.asset("assets/register.png"),
                        //full name field
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          validator: (val) {
                            return (val!.isEmpty)
                                ? "Name cannot be empty"
                                : null;
                          },
                          decoration: textinputdecoration.copyWith(
                              label: Text(
                                "Full Name",
                                style: TextStyle(),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: primaryColor,
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
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
                                  register();
                                },
                                child: Text(
                                  "Register",
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
                                  text: ' Login now',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, LoginPage());
                                    })
                            ],
                            text: "Already have an account?",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        )
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassord(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preference
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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
