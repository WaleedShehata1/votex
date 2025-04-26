import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sensor_screen.dart';

class AddSensorScreen extends StatefulWidget {
  const AddSensorScreen({super.key});

  @override
  State<AddSensorScreen> createState() => _AddSensorScreenState();
}

class _AddSensorScreenState extends State<AddSensorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Add Sensor",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hyperlinked Text Title
            RichText(
              text: const TextSpan(
                text:
                    "What is a Temperature and Humidity Sensor for a Refrigerator?",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Description
            const Text(
              "It is a small electronic device that accurately measures the temperature and humidity levels inside the refrigerator. It relies on advanced sensing technologies, such as DHT11, DHT22, or DS18B20 sensors, which provide real-time data that can be used to monitor performance and adjust cooling settings when needed.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 15),

            // Subtitle
            const Text(
              "How Does the Sensor Work?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 5),

            // Bullet Points
            const Text(
              "• Temperature Measurement: Uses thermal sensors to detect temperature changes and transmit data to a display screen or an electronic control unit.",
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 5),
            const Text(
              "• Humidity Measurement: Determines the humidity level inside the refrigerator, helping to prevent frost build-up or mold formation, especially on sensitive foods like fruits and vegetables.",
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 15),

            // Subtitle
            const Text(
              "Importance of the Sensor in the Refrigerator",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 5),

            // Highlighted Benefits with Blue Text
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        "✔ Helps maintain the optimal temperature for food storage.\n",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text:
                        "✔ Reduces the risk of food spoilage due to unexpected temperature or humidity changes.\n",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text:
                        "✔ Improves energy efficiency by adjusting cooling based on the recorded data.\n",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text:
                        "✔ Some smart sensors can be connected to mobile apps to alert you in case of any issues.",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Add Sensor Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const ControlPage());
                  // Implement sensor addition logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Add Sensor",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
