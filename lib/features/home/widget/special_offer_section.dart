import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votex/core/helper/route_helper.dart';

import 'offer_card.dart';

class SpecialOfferSection extends StatelessWidget {
  const SpecialOfferSection({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'See All',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.ratedBrandsScreen),
                    child: const CircleAvatar(
                      maxRadius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              OfferCard(
                name: 'Washing Machine',
                price: '10,675',
                oldPrice: '14,000',
              ),
              SizedBox(width: 10),
              OfferCard(
                name: 'Gas Cooker',
                price: '16,675',
                oldPrice: '18,000',
              )
            ],
          ),
        ],
      ),
    );
  }
}
