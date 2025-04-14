import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';

import '../../../core/model/item_model.dart';
import '../../offers/offers_screen.dart';
import 'offer_card.dart';

class SpecialOfferSection extends StatelessWidget {
  const SpecialOfferSection({super.key, required this.listItems});
  final List<ItemModel> listItems;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Special Offer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Get.to(const SpecialOfferScreen()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'See All',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteHelper.specialOfferScreen),
                      child: const CircleAvatar(
                        maxRadius: 15,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.arrow_forward_rounded),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                OfferCard(
                  name: "listItems[0].name",
                  price: "listItems[0].newPrice",
                  oldPrice: "listItems[0].oldPrice",
                  image: "listItems[0].imageIcon",
                  rate: "listItems[0].rate",
                  discount: "listItems[0].discount",
                ),
                // OfferCard(
                //   name: listItems[1].name,
                //   price: listItems[1].newPrice,
                //   oldPrice: listItems[1].oldPrice,
                //   image: listItems[1].imageIcon,
                //   rate: listItems[1].rate,
                //   discount: listItems[1].discount,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
