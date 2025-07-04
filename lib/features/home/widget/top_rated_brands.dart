import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voltex/core/model/brand_model.dart';

import '../../../controller/home/home_controller.dart';
import '../../rated brand/all_rated_brands.dart';
import 'brand_circle.dart';

// ignore: must_be_immutable
class TopRatedBrands extends StatelessWidget {
  TopRatedBrands({super.key, required this.listBrands});
  // List<QueryDocumentSnapshot> listBrands;
  List<BrandModel> listBrands;
  @override
  Widget build(BuildContext context) {
    final HomeControllerImp homeControllerImp = Get.put(HomeControllerImp());

    print(listBrands.length);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top rated brands',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Get.to(RatedBrandsScreen(brands: listBrands)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      maxRadius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            width: 200,
            child: Expanded(
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listBrands.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      homeControllerImp.brand = listBrands[i].BrandId;
                      homeControllerImp.subOrBrand();
                    },
                    child: BrandCircle(
                      brand: listBrands[i].brandName,
                      image: listBrands[i].imageUrl,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
