import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:votex/core/constants/images.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/helper/route_helper.dart';
import '../../core/widget/custom_button.dart';
import '../store/widget/product_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.reply_rounded, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            const Center(
              // child: Image.asset(
              //   Images.gasCooker,
              //   height: 200,
              //   fit: BoxFit.contain,
              // ),
              child: SizedBox(
                height: 200,
                width: 250,
                child: ModelViewer(
                  backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                  src: Images.gasCooker3D,
                  alt: 'A 3D model of an astronaut',
                  ar: true,
                  autoRotate: true,
                  iosSrc:
                      'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                  disableZoom: true,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Product Title, Rating & Price
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Washing Machine',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(LG)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Icon(Icons.star_half, color: Colors.orange, size: 16),
                    Text('(4/5)', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    "13.335",
                    style: TextStyle(
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  const Text('EGP 10.675',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () {},
                  buttonText: 'Add to cart',
                  boarderColor: AppColors.colorFont,
                  textColor: Colors.white,
                  width: 100.w,
                  height: 30,
                  borderRadius: BorderRadius.circular(10.r),
                  radius: Dimensions.paddingSizeExtremeLarge,
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomButton(
                  onPressed: () {},
                  buttonText: 'Buy now',
                  boarderColor: Colors.green,
                  textColor: Colors.white,
                  width: 100.w,
                  height: 30,
                  borderRadius: BorderRadius.circular(10.r),
                  radius: Dimensions.paddingSizeExtremeLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Product Variations (Images)
            // SizedBox(
            //   height: 60,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: List.generate(
            //       4,
            //       (index) => Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 5),
            //         child: Image.asset(
            //           Images.gasCooker,
            //           width: 50,
            //           height: 50,
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 15),

            // Video Player Section
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    Images.gasCooker,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Product Description
            const Text(
              "Use washing machines to easily clean your clothes. Featuring advanced technology, these machines "
              "help save water, energy, and time. Designed for efficiency, they provide a powerful and smooth washing experience.",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 15),

            // Ratings & Reviews Section
            const Text(
              'Ratings & Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star_half, color: Colors.orange, size: 20),
                SizedBox(width: 5),
                Text('4/5',
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
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mohamed Ahmed',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star_half,
                                color: Colors.orange, size: 18),
                          ],
                        ),
                        Text(
                          "Great washing machine, easy to use and energy-efficient!",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Product List
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 168.h,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.toNamed(RouteHelper.productDetailsScreen),
                  child: const ProductCard(
                    name: 'Washing Machine',
                    price: '10,675',
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
