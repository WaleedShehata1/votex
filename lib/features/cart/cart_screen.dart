import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:votex/core/model/item_model.dart';

import '../../controller/cart/cart_controller.dart';
import '../../core/constants/images.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';
import '../payment/payment_screen.dart';

final CartControllerImp cartController = Get.put(
  CartControllerImp(),
);
Map<String, dynamic> proposalItem = {
  "name": "Sensor",
  "price": 900.0,
  "image": Images.sensor,
  "count": 0,
};

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartControllerImp cartController = Get.put(
    CartControllerImp(),
  );

  @override
  void initState() {
    // cartController.call(proposalItem['price'] * proposalItem['count']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartControllerImp>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          // await cartController
          //     .call(proposalItem['price'] * proposalItem['count']);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: const Offset(80, -30),
                      child: Image.asset(
                        Images.shape,
                        width: 220,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Cart",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemCard(
                          controller.cartItems[index], proposalItem);
                    },
                  ),
                ),
                ProposalSection(proposalItem),
                // SummarySection(
                //     subtotal: controller.subtotal,
                //     sensorCost: controller.sensorCost,
                //     delivery: controller.deliveryFee,
                //     totalCost: controller.totalCost),
                Column(
                  children: [
                    SummaryRow(label: "Sensor", value: controller.sensorCost),
                    SummaryRow(label: "Subtotal", value: controller.subtotal),
                    // SummaryRow(label: "Delivery", value: controller.deliveryFee),
                    const Divider(thickness: 0.5),
                    SummaryRow(
                        label: "Total Cost",
                        value: controller.totalCost,
                        isBold: true),
                  ],
                ),
                // const CheckoutButton(),
                CustomButton(
                  onPressed: () {
                    // if (controller.cartItems.isNotEmpty ||
                    //     proposalItem["count"] != 0) {
                    //   Get.to(() => const PaymentScreen());
                    // }
                    Get.to(() => PaymentScreen());
                    // controller.createOrder();
                  },
                  height: 30.h,
                  buttonText: "Checkout",
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: 35.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// Cart Item Widget
class CartItemCard extends StatefulWidget {
  final ItemModel item;
  final Map<String, dynamic> proposalItem;
  const CartItemCard(this.item, this.proposalItem, {super.key});

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  bool add = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsetsDirectional.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xfff5f7fa),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CustomImageWidget(
                          image: widget.item.imageIcon,
                          height: 100.h,
                          width: 100.w,
                          fit: BoxFit.fitHeight,
                        ),
                        GestureDetector(
                          onTap: () {
                            cartController.removed(widget.item);
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.delete_outline_sharp,
                                color: Colors.red),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Efficient, quiet, and smart washing with advanced technology",
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 11.sp),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.itemName,
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "EGP ${widget.item.price}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                      Align(
                          alignment: AlignmentDirectional.center,
                          child:

                              //  const QuantitySelector()

                              Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  for (var item in cartController.cartItems) {
                                    if (widget.item.itemId == item.itemId) {
                                      if (widget.item.count > 1) {
                                        widget.item.count--;
                                        cartController.call(
                                            proposalItem['price'] *
                                                proposalItem['count']);
                                      }
                                    }
                                  }
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 7.w),
                                child: Text(widget.item.count.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              GestureDetector(
                                onTap: () => setState(() {
                                  for (var item in cartController.cartItems) {
                                    if (widget.item.itemId == item.itemId) {
                                      widget.item.count++;
                                    }
                                  }
                                  cartController.call(proposalItem['price'] *
                                      proposalItem['count']);
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      // CustomButton(
                      //   height: 30.h,
                      //   width: 100.w,
                      //   isBold: false,
                      //   buttonText: "Buy now",
                      //   textColor: Colors.white,
                      //   radius: 15.r,
                      //   color: Colors.green,
                      // ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       add = !add;
            //     });
            //   },
            //   child: Align(
            //       alignment: AlignmentDirectional.center,
            //       child: Row(
            //         children: [
            //           const Text("add sensor (optional)"),
            //           Icon(add ? Icons.expand_less : Icons.expand_more),
            //         ],
            //       )),
            // ),
            // add ? ProposalSection(widget.proposalItem) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

// Quantity Selector Widget
class QuantitySelector extends StatefulWidget {
  const QuantitySelector({super.key});

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            if (count > 1) count--;
          }),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.blue,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w),
          child: Text(count.toString(),
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        GestureDetector(
          onTap: () => setState(() {
            count++;
          }),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

// Proposal Section
class ProposalSection extends StatefulWidget {
  final Map<String, dynamic> proposal;

  const ProposalSection(this.proposal, {super.key});

  @override
  State<ProposalSection> createState() => _ProposalSectionState();
}

class _ProposalSectionState extends State<ProposalSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Sensor to make the device more distinctive. Buy it now"),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset(widget.proposal["image"],
                    height: 50, width: 50, fit: BoxFit.cover),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.proposal["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("EGP ${widget.proposal["price"]}",
                          style: const TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
                // CustomButton(
                //   height: 30.h,
                //   width: 100.w,
                //   isBold: false,
                //   buttonText: "Add sensor",
                //   textColor: Colors.white,
                //   radius: 15.r,
                //   color: Colors.blue,
                // ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        if (widget.proposal["count"] >= 1)
                          widget.proposal["count"] =
                              widget.proposal["count"] - 1;
                        cartController.sensorCost =
                            widget.proposal['price'] * widget.proposal['count'];
                        cartController.call(widget.proposal['price'] *
                            widget.proposal['count']);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w),
                      child: Text(widget.proposal["count"].toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        widget.proposal["count"] = widget.proposal["count"] + 1;
                        cartController.sensorCost =
                            widget.proposal['price'] * widget.proposal['count'];
                        cartController.call(widget.proposal['price'] *
                            widget.proposal['count']);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Summary Section
class SummarySection extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double totalCost;
  final double sensorCost;

  const SummarySection(
      {super.key,
      required this.subtotal,
      required this.sensorCost,
      required this.delivery,
      required this.totalCost});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRow(label: "Sensor", value: sensorCost),
        SummaryRow(label: "Subtotal", value: subtotal),
        SummaryRow(label: "Delivery", value: delivery),
        const Divider(thickness: 0.5),
        SummaryRow(label: "Total Cost", value: totalCost, isBold: true),
      ],
    );
  }
}

// Summary Row Widget
class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const SummaryRow(
      {super.key,
      required this.label,
      required this.value,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("EGP ${value.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
