import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votex/firebase_options.dart';

import 'core/functions/notification_api.dart';
import 'core/helper/get_di.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationApi.instance.initialize();

  await Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
      permanent: true);
  await Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
      permanent: true);
  await init();
  runApp(const MyApp());
}
