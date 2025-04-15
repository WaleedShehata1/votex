import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';

import '../../../controller/cart/cart_controller.dart';
import '../../../core/model/item_model.dart';
import '../../offers/offers_screen.dart';
import '../../product/proudct_details_screen.dart';
import 'offer_card.dart';

class SpecialOfferSection extends StatelessWidget {
  const SpecialOfferSection({
    super.key,
    required this.listItems,
    required this.listItemsOffer,
  });
  final List<ItemModel> listItemsOffer;
  final List<ItemModel> listItems;

  @override
  Widget build(BuildContext context) {
    final CartControllerImp cartControllerImp = Get.put(
      CartControllerImp(),
    );
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
          SizedBox(
            height: 195.h,
            width: double.maxFinite,
            child: Expanded(
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listItemsOffer.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 160,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () => Get.to(ProductDetailsScreen(
                        items: listItems,
                        item: listItemsOffer[i],
                      )),
                      child: OfferCard(
                        name: listItemsOffer[i].itemName,
                        price: listItemsOffer[i].price.toString(),
                        oldPrice: (listItemsOffer[i].price *
                            (1 - (listItemsOffer[i].discount / 100))),
                        image: listItemsOffer[i].imageIcon,
                        rate: listItemsOffer[i].rate,
                        discount: listItemsOffer[i].discount.toString(),
                        onPressed: () {
                          cartControllerImp.addItem(listItemsOffer[i]);
                          cartControllerImp.update();
                        },
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
