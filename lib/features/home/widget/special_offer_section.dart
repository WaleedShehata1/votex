import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';

import '../../../controller/cart/cart_controller.dart';
import '../../../controller/saved/saved_controller.dart';
import '../../../core/model/item_model.dart';
import '../../offers/offers_screen.dart';
import '../../product/proudct_details_screen.dart';
import 'offer_card.dart';

final CartControllerImp cartControllerImp = Get.put(
  CartControllerImp(),
);
final SavedControllerImp savedController = Get.put(
  SavedControllerImp(),
);

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
                onTap: () => Get.to(SpecialOfferScreen(
                  listItemsOffer: listItemsOffer,
                )),
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
                      onTap: () => Get.to(SpecialOfferScreen(
                        listItemsOffer: listItemsOffer,
                      )),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: 165,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () => Get.to(ProductDetailsScreen(
                        items: listItems,
                        item: listItemsOffer[i],
                      )),
                      child: OfferCard(
                        save: () {
                          savedController.addItem(listItemsOffer[i]);
                          savedController.update();
                        },
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
