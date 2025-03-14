import 'package:flutter/material.dart';

import '../../core/constants/images.dart';

class SpecialOfferScreen extends StatelessWidget {
  const SpecialOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title:
            const Text('Special Offer', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Choose Discount Text
            const Text(
              'Choose Your Discount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Discount Filter Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _discountButton('All', isSelected: true),
                _discountButton('10%'),
                _discountButton('20%', isSelected: true),
                _discountButton('30%'),
                _discountButton('40%'),
              ],
            ),
            const SizedBox(height: 10),

            // Discount Label
            const Text(
              '20% Discount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Products Grid
            Expanded(
              child: GridView.builder(
                itemCount: 8, // Number of washing machines
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 products per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75, // Aspect ratio of items
                ),
                itemBuilder: (context, index) {
                  return const ProductCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Discount button widget
  Widget _discountButton(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Product Card Widget
class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              Image.asset(
                Images.refrigerators, // Change this to your actual image
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '20% OFF',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Product Name
          const Text(
            'Washing Machine',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),

          // Price and Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EGP 10,675',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Text('4.2',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    Icon(Icons.star, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add to cart',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
