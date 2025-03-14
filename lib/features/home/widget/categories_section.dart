import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';

import 'category_card.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.specialOfferScreen),
                    child: CircleAvatar(
                      maxRadius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  )
                ],
              ),
            ],
          ),

          // ✅ Fix: Wrap GridView.builder in SizedBox to prevent infinite height issue
          SizedBox(
            height: 400.h, // Adjust this based on your needs
            child: GridView.builder(
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
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 190,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
