import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:votex/core/constants/colors.dart';
import 'package:votex/core/model/item_model.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../core/constants/images.dart';
import '../../core/constants/styles.dart';
import '../../core/widget/custom_text_field.dart';
import '../../core/widget/drop_down.dart';
import '../drawer/drawer.dart';
import '../product/proudct_details_screen.dart';
import 'widget/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerImp homeController = Get.put(
      HomeControllerImp(),
    );
    final CartControllerImp cartControllerImp = Get.put(
      CartControllerImp(),
    );
    if (homeController.selectedIndex == 1) {
      homeController.getItems();
    }
    return GetBuilder<HomeControllerImp>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.load();
          controller.selectType = 'الكل';
        },
        child: Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu_outlined, color: Colors.black),
              onPressed: () {
                controller.scaffoldKey.currentState?.openDrawer();
                controller.update();
              },
            ),
            title: Container(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 7.w, vertical: 5.h),
              decoration: BoxDecoration(
                  color: AppColors.colorFont,
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                "VOLTEX",
                style: robotoBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Images.store2,
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.fitHeight,
              ),
              // Search bar
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    vertical: 5.h, horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextField(
                      colorFill: Colors.white,
                      hintText: 'Search here',
                      width: 110.w,
                      height: 20.h,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 15.w,
                        color: AppColors.colorFont3,
                      ),
                      borderRadius: 3.r,
                      colorBorder: AppColors.colorFont,
                    ),
                    SizedBox(
                      width: 111.w,
                      height: 35.h,
                      child: DefaultDropdown(
                        fontSize: 12.sp,
                        iconSize: 17,
                        radius: 3.r,
                        value: controller.selectType,
                        labelText: 'Type',
                        colorBorder: Colors.grey.shade200,
                        items: controller.selectTypeList,
                        onChanged: (value) {
                          controller.selectType = value.toString();
                          controller
                              .filtterToType(controller.selectType.toString());
                          controller.update();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 110.w,
                      height: 35.h,
                      child: controller.filtterList.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DefaultDropdown(
                              fontSize: 12.sp,
                              iconSize: 15,
                              radius: 3.r,
                              icon: const Icon(Icons.filter_alt_outlined),
                              value: controller.filtter,
                              labelText: 'filtter',
                              colorBorder: Colors.grey.shade200,
                              items: controller.filtterList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                switch (value) {
                                  case "price LowToHig":
                                    controller
                                        .sortProducts(SortType.priceLowToHigh);
                                    break;
                                  case "price HighToLow":
                                    controller
                                        .sortProducts(SortType.priceHighToLow);
                                    break;
                                  case "oldest First":
                                    controller
                                        .sortProducts(SortType.oldestFirst);
                                    break;
                                  case "newest First":
                                    controller
                                        .sortProducts(SortType.newestFirst);
                                    break;
                                  case "from A To Z":
                                    controller.sortProducts(SortType.fromAToZ);
                                    break;
                                  case "from Z To A":
                                    controller.sortProducts(SortType.fromZToA);
                                    break;
                                  case 'normal':
                                    controller.sortProducts('normal');
                                    break;
                                }

                                controller.filtter = value.toString();
                                controller.update();
                              },
                            ),
                    ),
                  ],
                ),
              ),

              // Product Grid
              Expanded(
                child: controller.listItemAndFiltter.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 168.h,
                        ),
                        itemCount: controller
                            .listItemAndFiltter.length, // Sample items count
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Get.to(() => ProductDetailsScreen(
                                  item: controller.listItemAndFiltter[index],
                                  items: controller.listItemAndFiltter,
                                )),
                            child: ProductCard(
                              name:
                                  controller.listItemAndFiltter[index].itemName,
                              price: controller.listItemAndFiltter[index].price,
                              image: controller
                                  .listItemAndFiltter[index].imageIcon,
                              rate: controller.listItemAndFiltter[index].rate,
                              item: controller.listItemAndFiltter[index],
                              onPressed: () {
                                cartControllerImp.addItem(
                                    controller.listItemAndFiltter[index]);
                                cartControllerImp.update();
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          drawer: const AppDrawer(),
        ),
      );
    });
  }
}
