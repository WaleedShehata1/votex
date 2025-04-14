import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/route_helper.dart';
import '../../../core/model/subcategory_model.dart';
import '../../store/store_screen.dart';
import 'category_card.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key, required this.listSubCategoryes});
  final List<SubcategoryModel> listSubCategoryes;
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
                    onTap: () => Get.to(
                      const ProductListScreen(),
                    ),
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
            itemCount: listSubCategoryes.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CategoryCard(
                category: listSubCategoryes[index].nameCategores,
                image: listSubCategoryes[index].imageSubCategores,
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1,
              mainAxisExtent: 195,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
