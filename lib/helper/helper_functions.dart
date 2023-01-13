import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //Keys
  static String userLoggedInKey = "LOGGEEINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //saving the data in local storage for keeping user logged_in and out

  //getting the data in local storage for keeping user logged_in and out
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
