import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widget/custom_image_widget.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.image});
  final String category;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(5),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsetsDirectional.all(2),
                padding: const EdgeInsetsDirectional.all(2),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: CustomImageWidget(
                  width: 100.w,
                  height: 100.h,
                  image: image,
                  fit: BoxFit.fitWidth,
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xffdfe9ff),
                ),
                child: const Text('109', style: TextStyle(fontSize: 12)),
              ),
              Text(category, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
