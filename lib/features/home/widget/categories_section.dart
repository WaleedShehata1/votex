import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';

import 'category_card.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'See All',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    // onTap: () => Get.toNamed(RouteHelper.ratedBrandsScreen),
                    child: const CircleAvatar(
                      maxRadius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  )
                ],
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const CategoryCard(
                category: 'Washing Machine',
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.1,
              mainAxisExtent: 190,
            ),
          ),
        ],
      ),
    );
  }
}
