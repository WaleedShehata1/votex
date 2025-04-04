import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votex/core/constants/colors.dart';
import 'package:votex/core/helper/route_helper.dart';
import '../../core/constants/images.dart';
import '../../core/constants/styles.dart';
import '../../core/widget/custom_text_field.dart';
import '../../core/widget/drop_down.dart';
import '../drawer/drawer.dart';
import 'widget/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? selectType;
  List<String> selectTypeList = [
    "Refrigerator",
    "Freezer",
    "Oven",
    "Microwave",
    "Washing Machine"
  ];
  String? filtter;
  List<String> filtterList = [
    "Refrigerator",
    "Freezer",
    "Oven",
    "Microwave",
    "Washing Machine"
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_outlined, color: Colors.black),
          onPressed: () {
            setState(() {});
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Container(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 5.h),
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
                    value: selectType,
                    labelText: 'Type',
                    colorBorder: Colors.grey.shade200,
                    items: selectTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectType = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 110.w,
                  height: 35.h,
                  child: DefaultDropdown(
                    fontSize: 12.sp,
                    iconSize: 15,
                    radius: 3.r,
                    icon: const Icon(Icons.filter_alt_outlined),
                    value: filtter,
                    labelText: 'filtter',
                    colorBorder: Colors.grey.shade200,
                    items: filtterList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        filtter = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 168.h,
              ),
              itemCount: 6, // Sample items count
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.toNamed(RouteHelper.productDetailsScreen),
                  child: const ProductCard(
                    name: 'Washing Machine',
                    price: '10,675',
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
