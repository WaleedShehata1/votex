import 'package:flutter/material.dart';

import '../../../core/constants/images.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
  final String category;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, spreadRadius: 5, blurRadius: 5)
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsetsDirectional.all(2),
                padding: const EdgeInsetsDirectional.all(2),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: Image.asset(Images.refrigerators),
              ),
              Container(
                margin: const EdgeInsetsDirectional.all(2),
                padding: const EdgeInsetsDirectional.all(2),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: Image.asset(Images.refrigerators),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsetsDirectional.all(2),
                padding: const EdgeInsetsDirectional.all(2),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: Image.asset(Images.refrigerators),
              ),
              Container(
                margin: const EdgeInsetsDirectional.all(2),
                padding: const EdgeInsetsDirectional.all(2),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: Image.asset(Images.refrigerators),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xffdfe9ff)),
                child: const Text(
                  '109',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Text(category, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
