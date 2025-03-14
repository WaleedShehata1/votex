import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

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
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.asset(
                'assets/washing_machine.png',
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),

            // Product Title, Rating & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Washing Machine',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star_half, color: Colors.orange, size: 18),
                        SizedBox(width: 5),
                        Text('(4.2)', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
                Text(
                  'EGP 10,675',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Product Variations (Images)
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Image.asset(
                      'assets/washing_machine.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Video Player Section
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/washing_machine_video_thumbnail.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 50,
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Product Description
            const Text(
              "Use washing machines to easily clean your clothes. Featuring advanced technology, these machines "
              "help save water, energy, and time. Designed for efficiency, they provide a powerful and smooth washing experience.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 15),

            // Ratings & Reviews Section
            const Text(
              'Ratings & Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const Icon(Icons.star_half, color: Colors.orange, size: 20),
                const SizedBox(width: 5),
                const Text('4.5 (102 Reviews)',
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),

            const SizedBox(height: 10),

            // Review Card
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/user.png'),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mohamed Ahmed',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const Icon(Icons.star_half,
                                color: Colors.orange, size: 18),
                          ],
                        ),
                        const Text(
                          "Great washing machine, easy to use and energy-efficient!",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Related Products Section
            const Text(
              'Related Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Product List
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          index.isEven
                              ? 'assets/washing_machine.png'
                              : 'assets/oven.png',
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Washing Machine',
                          style: TextStyle(fontSize: 14)),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 14),
                          const Text('4.2', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Text(
                        'EGP 10,675',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text('Add to Cart',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
