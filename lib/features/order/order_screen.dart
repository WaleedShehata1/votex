import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/order/order_controller.dart';
import '../../core/widget/custom_image_widget.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (controller) {
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
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: ListView.builder(
            itemCount: controller.listOrder.length,
            itemBuilder: (context, index) {
              return OrderCard(
                title: controller.listOrder[index].title,
                description: controller.listOrder[index].description,
                orderNumber: controller.listOrder[index].orderNumber,
                date: controller.formatDate(controller.listOrder[index].date),
                image: controller.listOrder[index].image,
              );
            },
          ),
        ),
      );
    });
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
              child: CustomImageWidget(
                height: 60,
                width: 60,
                image: image,
                fit: BoxFit.cover,
              ),
              //  Image.network(
              //   image,
              //   height: 60,
              //   width: 60,
              //   fit: BoxFit.cover,
              // ),
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
                    "Order #$orderNumber",
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
            // TextButton(
            //   onPressed: () {
            //     // Handle review action
            //   },
            //   style: TextButton.styleFrom(
            //     backgroundColor: Colors.white,
            //     side: const BorderSide(color: Colors.blue),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8)),
            //   ),
            //   child: const Text(
            //     "Review",
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
