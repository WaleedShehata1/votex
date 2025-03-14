import 'package:flutter/material.dart';

import 'brand_circle.dart';

class TopRatedBrands extends StatelessWidget {
  const TopRatedBrands({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top rated brands',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.arrow_forward_rounded),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['LG', 'SAMSUNG', 'SHARP', 'Fresh']
                  .map((brand) => BrandCircle(
                        brand: brand,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
