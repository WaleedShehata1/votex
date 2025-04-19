import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/saved/saved_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/model/item_model.dart';
import '../../../core/widget/custom_button.dart';
import '../../../core/widget/custom_image_widget.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.rate,
    required this.item,
    required this.onPressed,
  });
  final ItemModel item;
  final String name;
  final String image;
  final double price;
  final String rate;
  final Function? onPressed;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  IconData? icon = Icons.favorite_border_outlined;

  final SavedControllerImp savedController = Get.put(
    SavedControllerImp(),
  );
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
            padding: const EdgeInsetsDirectional.symmetric(vertical: 3),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensure it takes only necessary space
              children: [
                CustomImageWidget(
                  image: widget.image,
                  height: 95,
                  width: 80,
                  fit: BoxFit.fitHeight,
                ),
                // Image.asset(
                //   Images.washing,
                //   height: 95,
                //   width: 80,
                //   fit: BoxFit.fitHeight,
                // ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 5),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child:
                        Text(widget.name, style: const TextStyle(fontSize: 14)),
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
                      child: Row(
                        children: [
                          Text(
                            widget.rate,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                          const Icon(Icons.star, size: 15, color: Colors.white),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 5),
                      child: Text(
                        'EGP ${widget.price}',
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
                  onPressed: widget.onPressed,
                  buttonText: 'Add to cart',
                  boarderColor: AppColors.colorFont,
                  textColor: Colors.white,
                  width: 105.h,
                  height: 25.w,
                  radius: Dimensions.paddingSizeExtremeLarge,
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: GestureDetector(
                onTap: () {
                  savedController.addItem(widget.item);
                  setState(() {
                    // for (var element in savedController.savedItems) {
                    //   if (element.itemId == widget.item.itemId) {
                    //     savedController.removed(widget.item);
                    //     icon = Icons.favorite_outlined;
                    //   }
                    // }
                    icon = Icons.favorite_outlined;
                  });
                },
                child: const Icon(Icons.favorite, color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
