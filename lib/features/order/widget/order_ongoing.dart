import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/dimensions.dart';
import '../../../core/constants/styles.dart';

class OrderOngoing extends StatelessWidget {
  const OrderOngoing({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(
                "عجلة محرك , دراجة كهربائية طراز m12 , عجلة محرك , دراجة كهربائية طراز m12 , عجلة محرك.. المزيد",
                maxLines: 4,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: const Color(0xff7f7f7f),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "المزيد",
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: const Color(0xff7f7f7f),
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          flex: 2,
          child: Text(
            "2 فبراير 2025",
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: const Color(0xff7f7f7f),
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 65.w,
                height: 24.h,
                decoration: BoxDecoration(
                    color: const Color(0xffeded47),
                    borderRadius: BorderRadius.circular(18.r)),
                child: Center(
                  child: Text(
                    "جارية",
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: const Color(0xff0a4f01),
                    ),
                  ),
                ),
              ),
              Container(
                width: 65.w,
                height: 24.h,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(18.r)),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "جارية",
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Icon(
                        Icons.block_flipped,
                        color: Colors.red,
                        size: 12.w,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
