import 'package:flutter/material.dart';
import 'package:voltex/core/constants/images.dart';
import 'package:voltex/core/model/item_model.dart';

import '../../core/widget/custom_image_widget.dart';
import 'widget/product_card.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.item});
  final ItemModel item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                  // child: Image.asset(
                  //   Images.gasCooker, // Replace with actual image
                  //   height: 180,
                  // ),
                  child: CustomImageWidget(
                image: item.imageUrl,
                height: 180,
              )),
              const SizedBox(height: 10),

              // Product Name
              Text(
                "${item.itemName} (${item.brandName})",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              // Rating Row
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star_half, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(item.rate),
                  const SizedBox(width: 8),
                  const Text("(223 Reviews)",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),

              // Price
              Text(
                "QAR ${item.price}",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 10),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black),
                      child: const Text("Add to Cart"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      child: const Text("Buy Now"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Product Description
              SizedBox(
                width: 200,
                height: 100,
                child: Text(
                  item.itemDescription,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 15),

              // Video Section
              Container(
                height: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        Images.gasCooker, // Replace with actual thumbnail
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.play_circle_fill,
                            size: 60, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Rating & Reviews
              const Text(
                "Rating & Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Review Card
              const ReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text("V", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Veronika",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(
                          4,
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 16)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Review Text
            Text(
              '"Great design, top washing with TurboWash and AI DD. Saves energy and water, super quiet. Highly recommended!"',
              style: TextStyle(color: Colors.grey[700]),
            ),
            // Expanded(
            //   child: GridView.builder(
            //     padding: const EdgeInsets.all(16.0),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10,
            //       childAspectRatio: 0.82,
            //     ),
            //     itemCount: 6, // Sample items count
            //     itemBuilder: (context, index) {
            //       return ProductCard(
            //         name: 'Washing Machine',
            //         price: '10,675',
            //         image: '',
            //         rate: '', item: ,
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
