import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/images.dart';
import '../../../core/widget/custom_image_widget.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.image,
  });
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
          BoxShadow(color: Colors.grey.shade200, spreadRadius: 5, blurRadius: 5)
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
                  width: 100,
                  height: 100,
                  image: image,
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
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

      //  Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Container(
      //           margin: const EdgeInsetsDirectional.all(2),
      //           padding: const EdgeInsetsDirectional.all(2),
      //           decoration: BoxDecoration(color: Colors.grey.shade300),
      //           child: CustomImageWidget(
      //             width: 50,
      //             height: 50,
      //             image: image,
      //           ),
      //         ),
      //         Container(
      //           margin: const EdgeInsetsDirectional.all(2),
      //           padding: const EdgeInsetsDirectional.all(2),
      //           decoration: BoxDecoration(color: Colors.grey.shade300),
      //           child: CustomImageWidget(
      //             image: image,
      //           ),
      //         ),
      //       ],
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Container(
      //           margin: const EdgeInsetsDirectional.all(2),
      //           padding: const EdgeInsetsDirectional.all(2),
      //           decoration: BoxDecoration(color: Colors.grey.shade300),
      //           child: CustomImageWidget(
      //             image: image,
      //           ),
      //         ),
      //         Container(
      //           margin: const EdgeInsetsDirectional.all(2),
      //           padding: const EdgeInsetsDirectional.all(2),
      //           decoration: BoxDecoration(color: Colors.grey.shade300),
      //           child: CustomImageWidget(
      //             image: image,
      //           ),
      //         ),
      //       ],
      //     ),
      //     const SizedBox(height: 5),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Container(
      //           padding: const EdgeInsets.all(5),
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(5),
      //               color: const Color(0xffdfe9ff)),
      //           child: const Text(
      //             '109',
      //             style: TextStyle(
      //               fontSize: 12,
      //             ),
      //           ),
      //         ),
      //         Text(category, style: const TextStyle(fontSize: 12)),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
