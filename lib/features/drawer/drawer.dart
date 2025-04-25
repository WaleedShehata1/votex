import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voltex/core/helper/route_helper.dart';

import '../../controller/home/home_controller.dart';
import '../sensor/sensor_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerImp homeController = Get.put(
      HomeControllerImp(),
    );
    return Drawer(
      width: 190.w,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 0.7,
                    )),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.black,
                ),
              ),
              Text((homeController.model?.userName).toString(),
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)), // ),
              const Divider(),
              // Drawer Items

              DrawerItem(
                icon: Icons.person_outlined,
                title: "Profile",
                onTap: () {
                  Get.toNamed(RouteHelper.profileScreen);
                },
              ),
              //  DrawerItem( onTap: () {
              //     Get.toNamed(RouteHelper.profileScreen);
              //   },
              //     icon: Icons.shopping_cart_outlined, title: "My Cart"),
              DrawerItem(
                  onTap: () {
                    Get.toNamed(RouteHelper.ordersScreen);
                  },
                  icon: Icons.local_shipping_outlined,
                  title: "Orders"),
              DrawerItem(
                  onTap: () {
                    Get.toNamed(RouteHelper.notificationsScreen);
                  },
                  icon: Icons.notifications_none,
                  title: "Notifications"),
              DrawerItem(
                  onTap: () {},
                  icon: Icons.chat_bubble_outline,
                  title: "Chat Bot"),
              DrawerItem(
                  onTap: () {
                    // Get.to(const SensorScreen());
                    Get.toNamed(RouteHelper.addSensorScreen);
                  },
                  icon: Icons.sensors,
                  title: "Sensors"),

              // Highlighted "About Us" Item
              DrawerItem(
                onTap: () {
                  Get.toNamed(RouteHelper.aboutUsScreen);
                },
                icon: Icons.info,
                title: "About us",
              ),
              DrawerItem(
                  onTap: () {
                    Get.toNamed(RouteHelper.settingsScreen);
                  },
                  icon: Icons.settings,
                  title: "Settings"),
              const SizedBox(height: 15),
              const Divider(color: Colors.grey, height: 2, thickness: 0.5),
              const SizedBox(height: 15),
              // Sign Out
              DrawerItem(onTap: () {}, icon: Icons.logout, title: "Sign Out"),
            ],
          ),
        ),
      ),
    );
  }
}

// Drawer Item Widget
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final Function()? onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10, vertical: 5),
          decoration: isSelected
              ? const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(25),
                    bottomEnd: Radius.circular(25),
                  ),
                )
              : null,
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
