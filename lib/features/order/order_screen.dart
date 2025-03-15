import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> orders = [
      {
        'title': 'washing machine (LG)',
        'description':
            'Refers to the amount of laundry the washing machine can handle in kilograms (e.g. 10kg, 15kg).',
        'orderNumber': '#92875157',
        'date': 'April 06',
        'image':
            'https://cdn-icons-png.flaticon.com/512/2903/2903976.png' // Replace with actual image URL
      },
      {
        'title': 'washing machine (LG)',
        'description':
            'Refers to the amount of laundry the washing machine can handle in kilograms (e.g. 10kg, 15kg).',
        'orderNumber': '#92875157',
        'date': 'April 06',
        'image':
            'https://cdn-icons-png.flaticon.com/512/2903/2903976.png' // Replace with actual image URL
      },
      {
        'title': 'washing machine (LG)',
        'description':
            'Refers to the amount of laundry the washing machine can handle in kilograms (e.g. 10kg, 15kg).',
        'orderNumber': '#92875157',
        'date': 'April 06',
        'image':
            'https://cdn-icons-png.flaticon.com/512/2903/2903976.png' // Replace with actual image URL
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
          "History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            return OrderCard(
              title: order['title']!,
              description: order['description']!,
              orderNumber: order['orderNumber']!,
              date: order['date']!,
              image: order['image']!,
            );
          },
        ),
      ),
    );
  }
}

// Order Card Widget
class OrderCard extends StatelessWidget {
  final String title;
  final String description;
  final String orderNumber;
  final String date;
  final String image;

  const OrderCard({
    super.key,
    required this.title,
    required this.description,
    required this.orderNumber,
    required this.date,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),

            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Order $orderNumber",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Review Button
            TextButton(
              onPressed: () {
                // Handle review action
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Review",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
