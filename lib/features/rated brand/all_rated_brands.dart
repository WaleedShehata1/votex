import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';

class RatedBrandsScreen extends StatelessWidget {
  const RatedBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'VOLTEX',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Title
            const Text(
              'ALL rated brands',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Brand Grid
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Number of rows
                itemBuilder: (context, index) {
                  return _buildBrandRow();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a single row of brands
  Widget _buildBrandRow() {
    List<Map<String, String>> brands = [
      {'name': 'LG', 'image': 'assets/lg.png'},
      {'name': 'SAMSUNG', 'image': 'assets/samsung.png'},
      {'name': 'SHARP', 'image': 'assets/sharp.png'},
      {'name': 'Fresh', 'image': 'assets/fresh.png'},
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: brands
            .map(
              (brand) => Column(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.specialOfferSection),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: AssetImage(brand['image']!),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    brand['name']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
