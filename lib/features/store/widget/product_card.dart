import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/shape/sale_shape.dart';
import '../../../core/widget/custom_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.oldPrice,
  });

  final String name;
  final String price;
  final String oldPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      // <-- Removed Expanded
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensure it takes only necessary space
              children: [
                Image.asset(
                  Images.washing,
                  height: 100,
                  width: 80,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 5),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(name, style: const TextStyle(fontSize: 14)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(15),
                          bottomEnd: Radius.circular(15),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            '4.2',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          Icon(Icons.star, size: 15, color: Colors.white),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 5),
                      child: Text(
                        'EGP $price',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () {},
                  buttonText: 'Add to cart',
                  boarderColor: AppColors.colorFont,
                  textColor: Colors.white,
                  width: 110,
                  height: 30,
                  radius: Dimensions.paddingSizeExtremeLarge,
                ),
              ],
            ),
          ),
          const Positioned(
            top: 8,
            left: 8,
            child: Icon(Icons.favorite, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
