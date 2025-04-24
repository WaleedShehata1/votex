import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/product/product_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../core/widget/custom_text_field.dart';
import '../product/proudct_details_screen.dart';
import '../store/widget/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isEnabl = true;
  final CartControllerImp cartControllerImp = Get.put(
    CartControllerImp(),
  );
  final ProductController productController = Get.put(
    ProductController(),
  );
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<HomeControllerImp>(
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: CustomTextField(
                  // controller: controller.search,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        // controller.getSearch(controller.search.text);
                      },
                      child: Image.asset(
                        Images.searchIcon,
                        width: 10.w,
                        fit: BoxFit.fill,
                        color: const Color(0xff7f7f7f),
                      ),
                    ),
                  ),
                  width: 260.w,
                  height: 40.h,
                  isEnabled: isEnabl,
                  colorFill: Colors.white,
                  colorBorder: AppColors.colorFont3,
                  hintText: "search".tr,
                  borderRadius: 17.r,
                  onChanged: (val) async {
                    setState(() {});
                    print(val);
                    await Future.delayed(const Duration(milliseconds: 600), () {
                      if (val != '') {
                        isEnabl = false;
                        controller.searchProductsByPartialName(val);
                        // return controller.getSearch(val);
                      }
                      isEnabl = true;
                    });
                  },
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    controller.itemListSearch.clear();
                    Get.back();
                  },
                ),
              ),
              body: controller.isLoadingSearch.value
                  ? Center(child: CircularProgressIndicator())
                  : controller.itemListSearch.isEmpty
                      ? Center(
                          child: Text(
                            'No Item Found',
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GridView.builder(
                            itemCount: controller.itemListSearch.length,
                            itemBuilder: (ctx, index) {
                              return GestureDetector(
                                onTap: () {
                                  productController.getCommints(
                                      id: controller
                                          .listItemAndFiltter[index].itemId!);
                                  productController.rate =
                                      controller.listItemAndFiltter[index].rate;
                                  Get.to(() => ProductDetailsScreen(
                                        item: controller
                                            .listItemAndFiltter[index],
                                        items: controller.listItemAndFiltter,
                                      ));
                                },
                                child: ProductCard(
                                  name: controller
                                      .listItemAndFiltter[index].itemName,
                                  price: controller
                                      .listItemAndFiltter[index].price,
                                  image: controller
                                      .listItemAndFiltter[index].imageIcon,
                                  rate:
                                      controller.listItemAndFiltter[index].rate,
                                  item: controller.listItemAndFiltter[index],
                                  onPressed: () {
                                    cartControllerImp.addItem(
                                        controller.listItemAndFiltter[index]);
                                    cartControllerImp.update();
                                  },
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 2,
                                    mainAxisExtent: 190.h),
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}
