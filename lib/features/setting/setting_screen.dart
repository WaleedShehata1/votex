import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/LocalizationController.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalizationController localizationController = Get.put(
    LocalizationController(sharedPreferences: Get.find()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
            const Text(
              "Language",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                title: Text(
                    localizationController.locale.languageCode == 'en'
                        ? "English"
                        : "العربية",
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                children: [
                  ListTile(
                    title: const Text("English"),
                    trailing: localizationController.locale.languageCode == 'en'
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        localizationController.setLanguage(
                          Locale(
                            AppConstants.languages[1].languageCode!,
                            AppConstants.languages[1].countryCode,
                          ),
                        );
                      });
                    },
                  ),
                  ListTile(
                    title: const Text("العربية"),
                    trailing: localizationController.locale.languageCode == 'ar'
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        localizationController.setLanguage(
                          Locale(
                            AppConstants.languages[0].languageCode!,
                            AppConstants.languages[0].countryCode,
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Currency Display
            const Text(
              "Currency",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("EGP", style: TextStyle(fontSize: 14)),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Delete My Account
            GestureDetector(
              onTap: () {
                // Implement delete account logic
              },
              child: const Text(
                "Delete My Account",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
