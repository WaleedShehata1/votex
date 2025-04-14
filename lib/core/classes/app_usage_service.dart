// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class AppUsageService {
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstTime =
        prefs.getBool(AppConstants.FirstLog) ?? true; // Default to true
    if (firstTime) {
      await prefs.setBool(
        AppConstants.FirstLog,
        false,
      ); // Mark as not first time
    }
    return firstTime;
  }

  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin =
        prefs.getBool(AppConstants.ISLOGIN) ?? false; // Default to true
    if (isLogin) {
      await prefs.setBool(AppConstants.ISLOGIN, true); // Mark as not first time
    }
    return isLogin;
  } // Get token

  static Future<bool> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.ISLOGIN) ?? false;
  }

  static Future<String> Token(newToken) async {
    final prefs = await SharedPreferences.getInstance();
    String token =
        prefs.getString(AppConstants.ISLOGIN) ?? ''; // Default to true
    if (token == '') {
      await prefs.setString(
        AppConstants.ISLOGIN,
        newToken,
      ); // Mark as not first time
    }
    return newToken;
  }

  // Save Login
  static Future<void> saveLogin(bool login) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.ISLOGIN, login);
  }

  // Get Login
  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.ISLOGIN) ?? false;
  }

  // Delete Login
  static Future<void> deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.ISLOGIN);
  }

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.TOKEN, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.TOKEN);
  }

  // Delete token
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.TOKEN);
  }

  // Save UserId
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userId, userId);
  }

  // Get UserId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userId);
  }

  // Delete UserId
  static Future<void> deleteUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userId);
  }

  // Save UserName
  static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userName, userName);
  }

  // Get UserName
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userName);
  }

  // Delete UserName
  static Future<void> deleteUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userName);
  }

  // Save UserEmail
  static Future<void> saveUserEmail(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userEmail, userEmail);
  }

  // Get UserEmail
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userEmail);
  }

  // Delete UserEmail
  static Future<void> deleteUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userEmail);
  }
}
