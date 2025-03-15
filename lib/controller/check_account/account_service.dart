import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountService extends GetxService {
  static AccountService get to => Get.find<AccountService>();

  Timer? _timer;
  final String apiUrl =
      "https://yourapi.com/check_account_status"; // Replace with your API

  Future<AccountService> init() async {
    return this;
  }

  void startAccountCheck() {
    _timer?.cancel(); // Prevent multiple timers
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) async {
      await checkAccountStatus();
    });
  }

  Future<void> checkAccountStatus() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer YOUR_TOKEN"
        }, // Add token if required
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['is_blocked'] == true) {
          _handleBlockedAccount();
        }
      } else {
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking account status: $e");
      }
    }
  }

  void _handleBlockedAccount() {
    _timer?.cancel();
    Get.snackbar("Account Blocked",
        "Your account has been blocked. Please contact support.");
    Get.offAllNamed('/login'); // Navigate to login screen
  }

  void stopAccountCheck() {
    _timer?.cancel();
  }
}
