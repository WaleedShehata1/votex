// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/styles.dart';

class PremiumHomeBanner extends StatelessWidget {
  const PremiumHomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Container(
          width: double.infinity,
          alignment: AlignmentDirectional.centerEnd,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 160.w,
                height: 70.h,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'PREMIUM HOME',
                      style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeOverLarge,
                          color: AppColors.colorFont),
                    ),
                    Text(
                      'Appliances for modern living',
                      style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Transform.translate(
              offset: const Offset(16, 0),
              child: Image.asset(
                Images.bubble1,
                width: 165,
                height: 130,
              ),
            ),
            Transform.translate(
              offset: const Offset(32, 10),
              child: Image.asset(
                Images.bubble2,
                width: 165,
                height: 130,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
