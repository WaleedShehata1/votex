import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/dimensions.dart';
import '../../core/constants/styles.dart';
import 'widget/order_canceled.dart';
import 'widget/order_completed.dart';
import 'widget/order_ongoing.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int selectedCondition = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "طلباتي",
          style: robotoBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge2,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 320,
            height: 48.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: const Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(31.r),
            ),
            child: Row(
              children: [
                buildConditionButton(
                  text: 'طلبات مكتملة',
                  index: 0,
                  context: context,
                  //   selectedCondition: selectedCondition,
                ),
                buildConditionButton(
                  text: 'طلبات جارية',
                  index: 1,
                  context: context,
                  // selectedCondition: selectedCondition,
                ),
                buildConditionButton(
                  text: 'طلبات ملغية',
                  index: 2,
                  context: context,
                  // selectedCondition: selectedCondition,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF6b65bd),
              borderRadius: BorderRadius.circular(6.r),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'المنتجات',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: robotoRegular.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'تاريخ إنشاء الطلب',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: robotoRegular.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
                Expanded(
                  flex: selectedCondition == 1 ? 4 : 2,
                  child: Text(
                    'حالة الطلب',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: robotoRegular.copyWith(
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 20.w,
                vertical: 10.h,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 0.7,
                  mainAxisExtent: 80.h,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return selectedCondition == 0
                      ? const OrderCompleted()
                      : selectedCondition == 1
                          ? const OrderOngoing()
                          : const OrderCanceled();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConditionButton({
    required String text,
    required int index,
    // required int selectedCondition,
    required BuildContext context,
  }) {
    bool isSelected = selectedCondition == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCondition = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        height: 40.h,
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(31.r),
          border:
              Border.all(color: isSelected ? Colors.white : Colors.transparent),
        ),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            style: robotoRegular.copyWith(
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}
