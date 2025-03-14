import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/dimensions.dart';
import '../../../core/constants/styles.dart';

class OrderCanceled extends StatelessWidget {
  const OrderCanceled({super.key});

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
          width: 20.w,
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
          width: 20.w,
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: 70.w,
            height: 24.h,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(18.r)),
            child: Center(
              child: Text(
                "ملغية",
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: const Color(0xff530400),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
