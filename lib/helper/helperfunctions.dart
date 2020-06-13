import 'package:shared_preferences/shared_preferences.dart';


class HelperFunctions{

  static String sharedPreferenceUserLoginKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';

  // ===================SAVING DATA TO SHARED PREFERENCE================

static Future<bool> saveuserLoggedInSharedPreference(bool isUserLoggedIn) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(sharedPreferenceUserLoginKey, isUserLoggedIn);
}
static Future<bool> saveUserNameSharedPreference(String userName) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedPreferenceUserNameKey, userName);
}

static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
}
// =============== Saving Data to Shared preference ==================

  static Future<bool> getuserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoginKey);
  }
  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }
  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

}