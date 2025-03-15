import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = "English"; // Default Language
  List<String> languages = ["English", "العربية"];

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
                title: Text(selectedLanguage,
                    style: const TextStyle(fontSize: 14, color: Colors.black)),
                children: [
                  ListTile(
                    title: const Text("English"),
                    trailing: selectedLanguage == "English"
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        selectedLanguage = "English";
                      });
                    },
                  ),
                  ListTile(
                    title: const Text("العربية"),
                    trailing: selectedLanguage == "العربية"
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        selectedLanguage = "العربية";
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
