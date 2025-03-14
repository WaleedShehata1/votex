import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/styles.dart';

class BrandCircle extends StatelessWidget {
  const BrandCircle({
    super.key,
    required this.brand,
  });
  final String brand;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            border: Border.all(width: 0.2, color: AppColors.colorFont3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: Image.asset(Images.refrigerators),
            ),
            const SizedBox(height: 5),
            Text(
              brand,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
