// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voltex/core/constants/images.dart' show Images;
import 'package:voltex/core/model/item_model.dart';

import '../../controller/product/product_controller.dart';
import '../../controller/saved/saved_controller.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/styles.dart';
import '../../core/helper/route_helper.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SavedControllerImp>(
        init: SavedControllerImp(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: const Offset(80, -30),
                      child: Image.asset(
                        Images.shape,
                        width: 250,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.625,
                  width: double.infinity,
                  child: ListView.builder(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.w, vertical: 5.h),
                    itemCount: controller.savedItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          // onTap: () {productController.getCommints(id: id)
                          //   Get.toNamed(RouteHelper.productDetailsScreen);
                          // },
                          child: SavedItemCard(controller.savedItems[index]));
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

// Saved Item Widget
class SavedItemCard extends StatelessWidget {
  final ItemModel item;

  const SavedItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: const Color(0xfff5f7fa),
                borderRadius: BorderRadius.circular(10.r)),
            child: CustomImageWidget(
              height: 110.h,
              width: 100.w,
              fit: BoxFit.fitHeight,
              image: item.imageIcon,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Efficient, quiet, and smart washing with advanced technology",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11.sp,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.itemName,
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "EGP ${item.price}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 20.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: const Color(0xfff5f7fa),
                        ),
                        child: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final SavedControllerImp savedController = Get.put(
      SavedControllerImp(),
    );
    showDialog(
      barrierColor: const Color.fromARGB(255, 160, 160, 160).withOpacity(0.45),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          title: Center(
            child: Text(
              "Remove the product from favorites",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                // color: Colors.blue,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  onPressed: () {
                    savedController.removed(item);
                    Get.back();
                  },
                  buttonText: 'Yes',
                  boarderColor: Colors.blue,
                  textColor: Colors.white,
                  width: 80.w,
                  height: 25.h,
                  radius: Dimensions.paddingSizeExtremeLarge,
                ),
                CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  buttonText: 'close',
                  boarderColor: Colors.blue,
                  textColor: Colors.white,
                  width: 80.w,
                  height: 25.h,
                  radius: Dimensions.paddingSizeExtremeLarge,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
