// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voltex/core/constants/colors.dart';
import 'package:voltex/core/constants/dimensions.dart';

import '../../controller/home/home_controller.dart';
import '../../core/constants/images.dart';
import '../cart/cart_screen.dart';
import '../favorite/favorite_screen.dart';
import '../store/store_screen.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeControllerImp homeController = Get.put(
    HomeControllerImp(),
  );

  static List<Widget> _widgetOption = [
    const HomeScreen(),
    const ProductListScreen(),
    CartScreen(),
    const SavedItemsScreen(),
  ];
  void onItemTapped(int index) {
    setState(() {
      homeController.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOption.elementAt(homeController.selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        backgroundColor: const Color(0xffeeeeee),
        currentIndex: homeController.selectedIndex,
        selectedItemColor: const Color.fromARGB(78, 9, 15, 71),
        unselectedItemColor: const Color.fromARGB(78, 9, 15, 71),
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(1),
              height: 25.h,
              width: 25.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: homeController.selectedIndex == 0
                    ? AppColors.iconAppBar
                    : Colors.white,
              ),
              child: Icon(
                Icons.home_outlined,
                color: homeController.selectedIndex == 0
                    ? Colors.white
                    : const Color.fromARGB(78, 9, 15, 71),
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(1),
                height: 25.h,
                width: 25.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: homeController.selectedIndex == 1
                      ? AppColors.iconAppBar
                      : Colors.white,
                ),
                child: Image.asset(
                  homeController.selectedIndex == 1
                      ? Images.iconShopping_cart2
                      : Images.iconShopping_cart,
                ),
              ),
              label: 'Store'),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(1),
                height: 25.h,
                width: 25.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: homeController.selectedIndex == 2
                      ? AppColors.iconAppBar
                      : Colors.white,
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: homeController.selectedIndex == 2
                      ? Colors.white
                      : const Color.fromARGB(78, 9, 15, 71),
                ),
              ),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(1),
                height: 25.h,
                width: 25.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: homeController.selectedIndex == 3
                      ? AppColors.iconAppBar
                      : Colors.white,
                ),
                child: Icon(
                  Icons.favorite,
                  color: homeController.selectedIndex == 3
                      ? Colors.white
                      : const Color.fromARGB(78, 9, 15, 71),
                ),
              ),
              label: 'Save'),
        ],
      ),
    );
  }
}
