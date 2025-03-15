// ignore_for_file: constant_identifier_names, unused_element, file_names

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

// ignore: avoid_classes_with_only_static_members
class PreferenceUtils {
  static const PREF_CACHETIME = 'cachedProductTime';
  static const TOKEN = 'TOKEN';
  static const MacAddress = 'MacAddress';
  static const UserName = 'UserName';
  static const UserCode = 'UserCode';
  static const UserId = 'UserId';
  static const Connectivity = 'Connectivity';

  static const ISLOGIN = 'ISLOGIN';
  static const ISFirstLog = 'ISFirstLog';
  static const Name = 'Name';
  static const EmailUser = 'EmailUser';
  static const IsOwner = 'Owner';
  static const IsUser = 'IsUser ';
  static const IsCompany = 'IsCompany';
  static const companyType = 'companyType';

  static Future<SharedPreferences> get _instance async =>
      prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences? prefs;
}
