// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:chat_app_firebase/helper/helper_functions.dart';
import 'package:chat_app_firebase/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //register function
  Future registerUserWithEmailAndPassord(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        //call our database to update the user data
        await DatabaseServices(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  //login function
  Future loggInWithUserNameAndPassord(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  //signout function
  Future signout() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
