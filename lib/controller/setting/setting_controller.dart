import 'package:get/get.dart';

import '../LocalizationController.dart';

class SettingController extends GetxController {
  final LocalizationController localizationController = Get.put(
    LocalizationController(sharedPreferences: Get.find()),
  );
}
