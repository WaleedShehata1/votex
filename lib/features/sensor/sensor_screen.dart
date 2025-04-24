// Splash Screen with Animated Logo
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Sensor extends StatefulWidget {
  const Sensor({super.key});

  @override
  State<Sensor> createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SensorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.databaseURL =
        'https://refmonitor-92db2-default-rtdb.asia-southeast1.firebasedatabase.app/';
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Initialize animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start animation
    _controller.forward();

    // // Navigate to the main screen after 3 seconds
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const ControlPage()),
    //   );
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const ControlPage();
  }
}

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final DatabaseReference dbRef = FirebaseDatabase.instance
      .ref('System'); // Firebase reference for 'System'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Refrigerator Monitoring System",
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DatabaseEvent>(
          stream: dbRef.onValue, // Use the stream for real-time updates
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show loading while waiting
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // Retrieve the data if available
            final data = snapshot.data?.snapshot.value;
            if (data is Map) {
              Map<String, dynamic> sensorData = Map<String, dynamic>.from(data);

              return ListView(
                children: [
                  _buildGadget(
                    title: "Humidity",
                    value: "${sensorData['Humidity'] ?? 0}%",
                    icon: Icons.opacity,
                    color: Colors.blue,
                  ),
                  _buildGadget(
                    title: "Light",
                    value: sensorData['Light'] ?? false ? 'On' : 'Off',
                    icon: sensorData['Light'] ?? false
                        ? Icons.lightbulb
                        : Icons.lightbulb_outline,
                    color: sensorData['Light'] ?? false
                        ? Colors.amber
                        : Colors.grey,
                  ),
                  _buildGadget(
                    title: "Temperature",
                    value: "${sensorData['Temp'] ?? 0} °C",
                    icon: Icons.thermostat,
                    color: Colors.red,
                  ),
                  _buildGadget(
                    title: "Vibration",
                    value: "${sensorData['Vibration'] ?? 0}",
                    icon: Icons.vibration,
                    color: Colors.green,
                  ),
                  _buildGadget(
                    title: "Door",
                    value: sensorData['door'] ?? false ? 'Open' : 'Closed',
                    icon: sensorData['door'] ?? false
                        ? Icons.meeting_room
                        : Icons.door_sliding,
                    color: sensorData['door'] ?? false
                        ? Colors.orange
                        : Colors.green,
                  ),
                ],
              );
            }
            return const Center(child: Text("No data available"));
          },
        ),
      ),
    );
  }

  // Helper method to build a gadget-like UI for each reading
  Widget _buildGadget({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
