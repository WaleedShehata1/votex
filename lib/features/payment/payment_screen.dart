import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voltex/core/constants/images.dart';

import '../../controller/account/account_controller.dart';
import '../../controller/cart/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/styles.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';
import '../../core/widget/custom_snackbar.dart';
import '../../core/widget/custom_text_field.dart';

final CartControllerImp cartController = Get.put(
  CartControllerImp(),
);

final AccountControllerImp accountControllerImp = Get.put(
  AccountControllerImp(),
);

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isStandardShipping = true;
  @override
  void initState() {
    cartController.onInit();
    accountControllerImp.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Payment",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: double.maxFinite,
              ),
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: const Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shipping Address",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            accountControllerImp.address.text,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          barrierColor:
                              const Color(0xffd9d9d9).withOpacity(0.45),
                          backgroundColor: Colors.transparent,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return ShippingAddressScreen();
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: const Color(0xff248ECF)),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: const Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(10.r)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Information",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        accountControllerImp.phoneNumber.text,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        accountControllerImp.model?.email ?? '',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Items",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: const Color(0xffE5EBFC)),
                    child: Text(
                      cartController.cartItems.length.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(height: 10),
              Column(
                children: cartController.cartItems.map((item) {
                  return _buildItemRow(
                      item.itemName,
                      item.brandName,
                      item.imageIcon,
                      item.price.toString(),
                      item.count.toString());
                }).toList(),
              ),
              // _buildItemRow('Gas Cooker', 'LG', Images.gasCooker, '16.675'),
              // _buildItemRow(
              //     'Washing Machine', 'fresh', Images.gasCooker, '10.675'),
              SizedBox(height: 20),
              Text('Shipping Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildShippingOption(true, 'Standard', '5-7 days', 'FREE'),
              _buildShippingOption(false, 'Express', '1-2 days', '\$12.00'),
              Text(
                'Delivered on or before Thursday, 23 April 2025',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // GestureDetector(
                  //   onTap: () {

                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(3.w),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20.r),
                  //         color: const Color(0xff248ECF)),
                  //     child: const Icon(
                  //       Icons.edit,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(height: 10),
              Chip(
                label: Text('Card', style: TextStyle(color: Colors.blueAccent)),
                backgroundColor: Colors.blue.shade50,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('EGP ${cartController.totalCost}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text('Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(width: 10),
                  CustomButton(
                    onPressed: () {
                      if (accountControllerImp.address.text.isNotEmpty) {
                        showModalBottomSheet(
                          barrierColor:
                              const Color(0xffd9d9d9).withOpacity(0.45),
                          backgroundColor: Colors.transparent,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return VisaCard();
                          },
                        );
                      } else {
                        showCustomSnackBar('enter your address'.tr,
                            isError: true);
                      }

                      // cartController.createOrder(
                      //   address: accountControllerImp.address,
                      //   phoneNumber: accountControllerImp.phoneNumber,
                      // );
                    },
                    buttonText: 'pay',
                    boarderColor: Colors.black,
                    textColor: Colors.white,
                    width: 100.w,
                    height: 35.h,
                    color: Colors.black,
                    radius: Dimensions.paddingSizeDefault,
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemRow(
    String name,
    String type,
    String imageAsset,
    String price,
    String count,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50.w,
                height: 48.h,
                padding:
                    EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(0, 0), blurRadius: 5)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: CustomImageWidget(
                  image: imageAsset,
                  width: 40,
                  height: 40,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 5.w,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xffE5EBFC)),
                child: Text(
                  count,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: name,
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: ', type ($type)',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ),
          Text('EGP $price',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildShippingOption(
      bool standard, String label, String time, String cost) {
    return GestureDetector(
      onTap: () => setState(() {
        isStandardShipping = standard;
        cartController.deliveryFee = cost == 'FREE' ? 0 : 12;
        cartController.deliveryTime = time;
        cartController.call();
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isStandardShipping == standard
              ? Colors.blue.shade50
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isStandardShipping == standard
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isStandardShipping == standard
                  ? Colors.blueAccent
                  : Colors.grey,
            ),
            SizedBox(width: 12),
            Text(label),
            Spacer(),
            Container(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                  color: Color(0xffF5F8FF),
                  borderRadius: BorderRadius.circular(3.r)),
              child: Text(time, style: TextStyle(color: Color(0xff248ECF))),
            ),
            SizedBox(width: 12),
            Text(cost, style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Address'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: SizedBox(),
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    children: [
                      Text(
                        'Country',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text('Egypt', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.grey.shade400),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              CustomTextField(
                hintText: 'Address',
                borderRadius: 5,
                colorBorder: Colors.transparent,
                controller: cartController.address,
              ),
              // const Text(
              //   'Address',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 6),
              // SizedBox(
              //   height: 30.h,
              //   child: TextField(
              //     controller: cartController.address,
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Colors.white,
              //       border: border,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Town / City',
                borderRadius: 5,
                colorBorder: Colors.transparent,
                controller: cartController.address2,
              ),

              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Postcode',
                borderRadius: 5,
                colorBorder: Colors.transparent,
                controller: cartController.address3,
              ),

              const SizedBox(height: 24),
              CustomButton(
                onPressed: () {
                  accountControllerImp.address.text =
                      cartController.address.text +
                          ',' +
                          cartController.address2.text +
                          ',' +
                          cartController.address3.text;
                  accountControllerImp.update();
                  Get.back();
                },
                buttonText: 'Save Changes',
                boarderColor: AppColors.colorFont,
                textColor: Colors.white,
                width: double.maxFinite,
                height: 35.h,
                color: Colors.blue,
                radius: Dimensions.paddingSizeSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VisaCard extends StatelessWidget {
  const VisaCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );

    return GetBuilder<CartControllerImp>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payment Methods'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: SizedBox(),
        ),
        backgroundColor: const Color(0xFFF7F9FC),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: 'Card Number',
                  inputType: TextInputType.emailAddress,
                  borderRadius: Dimensions.radiusLarge,
                  controller: controller.cardNumber,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Card Name',
                  inputType: TextInputType.emailAddress,
                  borderRadius: Dimensions.radiusLarge,
                  controller: controller.cardName,
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  hintText: 'date Exp',
                  inputType: TextInputType.emailAddress,
                  borderRadius: Dimensions.radiusLarge,
                  controller: controller.cardExp,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'cvv',
                  inputType: TextInputType.emailAddress,
                  borderRadius: Dimensions.radiusLarge,
                  controller: controller.cvv,
                ),
                const SizedBox(height: 6),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: () {
                    cartController.getVisa();
                  },
                  buttonText: 'next',
                  boarderColor: AppColors.colorFont,
                  textColor: Colors.white,
                  width: double.maxFinite,
                  height: 35.h,
                  color: Colors.blue,
                  radius: Dimensions.paddingSizeSmall,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
