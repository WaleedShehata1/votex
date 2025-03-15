import 'package:flutter/material.dart';
import 'package:votex/core/constants/images.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> notifications = [
      {
        'title': 'We Have New Products With Offers',
        'time': '7 min ago',
        'price': 'EGP 10.675',
        'oldPrice': 'EGP 10.675',
        'image':
            'https://www.lenovo.com/medias/lenovo-laptop-thinkpad-x1-carbon-gen-9-hero.png?context=bWFzdGVyfHJvb3R8NzAxNzJ8aW1hZ2UvcG5nfGgyZS9oYzgvMTEzNjUyMTk0OTc2MjIucG5nfDk1NGI2OGNlZDA4NjVkM2U1MWJmNGU5OTU0NjJmMjY0NzNhOGYyZmYzMzlmOWIzMTlkZjg2OWY1ZmFkODRmZDM'
      },
      {
        'title': 'We Have New Products With Offers',
        'time': '10 min ago',
        'price': 'EGP 10.675',
        'oldPrice': 'EGP 10.675',
        'image':
            'https://www.lenovo.com/medias/lenovo-laptop-thinkpad-x1-carbon-gen-9-hero.png?context=bWFzdGVyfHJvb3R8NzAxNzJ8aW1hZ2UvcG5nfGgyZS9oYzgvMTEzNjUyMTk0OTc2MjIucG5nfDk1NGI2OGNlZDA4NjVkM2U1MWJmNGU5OTU0NjJmMjY0NzNhOGYyZmYzMzlmOWIzMTlkZjg2OWY1ZmFkODRmZDM'
      },
      {
        'title': 'We Have New Products With Offers',
        'time': '12 min ago',
        'price': 'EGP 10.675',
        'oldPrice': 'EGP 10.675',
        'image':
            'https://www.lenovo.com/medias/lenovo-laptop-thinkpad-x1-carbon-gen-9-hero.png?context=bWFzdGVyfHJvb3R8NzAxNzJ8aW1hZ2UvcG5nfGgyZS9oYzgvMTEzNjUyMTk0OTc2MjIucG5nfDk1NGI2OGNlZDA4NjVkM2U1MWJmNGU5OTU0NjJmMjY0NzNhOGYyZmYzMzlmOWIzMTlkZjg2OWY1ZmFkODRmZDM'
      }
    ];

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
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  return NotificationCard(
                    title: notification['title']!,
                    time: notification['time']!,
                    price: notification['price']!,
                    oldPrice: notification['oldPrice']!,
                    image: notification[Images.gasCooker]!,
                  );
                },
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle delete all
                },
                child: const Text(
                  "Delete All",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Notification Card Widget
class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final String price;
  final String oldPrice;
  final String image;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.price,
    required this.oldPrice,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            // Notification Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        oldPrice,
                        style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Time and Delete Icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    // Handle delete action
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 22,
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
