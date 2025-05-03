import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/cart/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/images.dart';
import '../../core/model/item_model.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';

final CartControllerImp cartController = Get.put(CartControllerImp());

class SpecialOfferScreen extends StatelessWidget {
  const SpecialOfferScreen({super.key, required this.listItemsOffer});
  final List<ItemModel> listItemsOffer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Special Offer',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Choose Discount Text
            // const Text(
            //   'Choose Your Discount',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 8),

            // // Discount Filter Bar
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     _discountButton('All', isSelected: true),
            //     _discountButton('10%'),
            //     _discountButton('20%', isSelected: false),
            //     _discountButton('30%'),
            //     _discountButton('40%'),
            //   ],
            // ),
            // const SizedBox(height: 10),

            // // Discount Label
            // const Text(
            //   '20% Discount',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 10),

            // Products Grid
            Expanded(
              child: GridView.builder(
                itemCount: listItemsOffer.length, // Number of washing machines
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 products per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 205.h,
                  childAspectRatio: 0.75, // Aspect ratio of items
                ),
                itemBuilder: (context, index) {
                  return ProductCardOffer(
                    offer: listItemsOffer[index].discount,
                    image: listItemsOffer[index].imageIcon,
                    itemName: listItemsOffer[index].itemName,
                    rate: listItemsOffer[index].rate,
                    price: listItemsOffer[index].price,
                    onPressed: () {
                      cartController.addItem(listItemsOffer[index]);
                      cartController.update();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Discount button widget
  Widget _discountButton(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Product Card Widget
class ProductCardOffer extends StatelessWidget {
  const ProductCardOffer({
    super.key,
    this.onPressed,
    required this.offer,
    required this.itemName,
    required this.rate,
    required this.price,
    required this.image,
  });
  final Function? onPressed;
  final double offer;
  final String itemName;
  final String rate;
  final String image;
  final double price;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              CustomImageWidget(
                height: 95.h,
                width: double.infinity,
                fit: BoxFit.fitHeight,
                image: image,
              ),
              // Image.asset(
              //   Images.refrigerators, // Change this to your actual image
              //   height: 95.h,
              //   width: double.infinity,
              //   fit: BoxFit.fitHeight,
              // ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${offer.toStringAsFixed(0)}% OFF',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(itemName, style: TextStyle(fontSize: 14)),
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
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    Icon(Icons.star, size: 15, color: Colors.white),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      price.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      ((price * (1 - (offer / 100))).toStringAsFixed(2)),
                      style: TextStyle(
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
    );
  }
}
