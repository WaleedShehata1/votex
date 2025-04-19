import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votex/core/constants/images.dart';

import '../../controller/account/account_controller.dart';
import '../../controller/cart/cart_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/styles.dart';
import '../../core/widget/custom_button.dart';

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
                      Images.gasCooker,
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
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        barrierColor: const Color(0xffd9d9d9).withOpacity(0.45),
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
                      cartController.createOrder(
                        address: accountControllerImp.address,
                        phoneNumber: accountControllerImp.phoneNumber,
                      );
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
                child: Image.asset(
                  imageAsset,
                  width: 40,
                  height: 40,
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
  ShippingAddressScreen({Key? key}) : super(key: key);
  var address = TextEditingController();
  var address2 = TextEditingController();
  var address3 = TextEditingController();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Country',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text('Egypt', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
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

            const Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30.h,
              child: TextField(
                controller: address,
                decoration: InputDecoration(
                  hintText: '42, River Street, Maple Heights, Sunrise Ward',
                  filled: true,
                  fillColor: Colors.white,
                  border: border,
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Town / City',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30.h,
              child: TextField(
                controller: address2,
                decoration: InputDecoration(
                  hintText: 'Bengaluru, Karnataka 560023',
                  filled: true,
                  fillColor: Colors.white,
                  border: border,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Postcode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30.h,
              child: TextField(
                controller: address3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '70000',
                  filled: true,
                  fillColor: Colors.white,
                  border: border,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                accountControllerImp.address.text =
                    address.text + address2.text + address3.text;
              },
              buttonText: 'Save Changes',
              boarderColor: AppColors.colorFont,
              textColor: Colors.white,
              width: double.maxFinite,
              height: 35.h,
              color: Colors.blue,
              radius: Dimensions.paddingSizeSmall,
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     onPressed: () {
            //       // Save logic here
            //     },
            //     child: const Text(
            //       'Save Changes',
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //     ),
            //   ),
            // )
          ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Card Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30.h,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'KAREEM ALI MOHAMED',
                  filled: true,
                  fillColor: Colors.white,
                  border: border,
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Card Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30.h,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '2458 2546 2356 2458',
                  filled: true,
                  fillColor: Colors.white,
                  border: border,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'data',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30.h,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '06/31',
                  filled: true,
                  fillColor: Colors.white,
                  border: border,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'cvv',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 30.h,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '123',
                  filled: true,
                  fillColor: Colors.white,
                  border: border,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                // Save logic here
              },
              buttonText: 'next',
              boarderColor: AppColors.colorFont,
              textColor: Colors.white,
              width: double.maxFinite,
              height: 35.h,
              color: Colors.blue,
              radius: Dimensions.paddingSizeSmall,
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     onPressed: () {
            //       // Save logic here
            //     },
            //     child: const Text(
            //       'Save Changes',
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
