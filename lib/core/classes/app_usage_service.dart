import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class AppUsageService {
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstTime =
        prefs.getBool(AppConstants.FirstLog) ?? true; // Default to true
    if (firstTime) {
      await prefs.setBool(
          AppConstants.FirstLog, false); // Mark as not first time
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
  }
}
