import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/saved/saved_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/shape/sale_shape.dart';
import '../../../core/widget/custom_button.dart';
import '../../../core/widget/custom_image_widget.dart';

// ignore: must_be_immutable
class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.rate,
    required this.discount,
    required this.newPrice,
    required this.onPressed,
    this.save,
  });
  final Function? onPressed;
  final void Function()? save;
  final String name;
  final String price;
  final String image;
  final String discount;
  final String rate;
  final double newPrice;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
                children: [
                  CustomImageWidget(
                    height: 100,
                    width: 80,
                    fit: BoxFit.fitWidth,
                    image: image,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(name, style: const TextStyle(fontSize: 14)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
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
                              rate,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'EGP ${newPrice.toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    onPressed: onPressed,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: save,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                ), // Sale Ribbon
                ClipPath(
                  clipper: SaleBannerClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(10),
                      ),
                    ),
                    width: 58.w,
                    height: 58.h,
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Transform.rotate(
                          angle: 0.7,
                          child: Text(
                            "${discount.substring(0, 2)}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
