import 'package:flutter/material.dart';
import 'package:votex/core/constants/images.dart' show Images;

class SavedItemsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedItems = [
    {"name": "Washing Machine", "price": 10675.00, "image": Images.gasCooker},
    {"name": "Washing Machine", "price": 10675.00, "image": Images.gasCooker},
    {"name": "Washing Machine", "price": 10675.00, "image": Images.gasCooker},
    {"name": "Washing Machine", "price": 10675.00, "image": Images.gasCooker},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text("Save",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(width: 6),
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 4),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: Text(
                savedItems.length.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: savedItems.length,
          itemBuilder: (context, index) {
            return SavedItemCard(savedItems[index]);
          },
        ),
      ),
    );
  }
}

// Saved Item Widget
class SavedItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  SavedItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(item["image"],
                height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Efficient, quiet, and smart washing with advanced technology",
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item["name"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "EGP ${item["price"].toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {},
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
