import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votex/core/constants/images.dart';

import '../drawer/drawer.dart';
import '../store/store_screen.dart';

class RatedBrandsScreen extends StatefulWidget {
  const RatedBrandsScreen({super.key});

  @override
  State<RatedBrandsScreen> createState() => _RatedBrandsScreenState();
}

class _RatedBrandsScreenState extends State<RatedBrandsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
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
      drawer: const AppDrawer(),
    );
  }

  // Function to build a single row of brands
  Widget _buildBrandRow() {
    List<Map<String, String>> brands = [
      {'name': 'LG', 'image': Images.brand4},
      {'name': 'SAMSUNG', 'image': Images.brand3},
      {'name': 'SHARP', 'image': Images.brand2},
      {'name': 'Fresh', 'image': Images.brand},
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
                    onTap: () => Get.to(const ProductListScreen()),
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
