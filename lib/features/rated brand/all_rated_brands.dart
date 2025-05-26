import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/home/home_controller.dart';
import '../../core/model/brand_model.dart';
import '../../core/widget/custom_image_widget.dart';
import '../drawer/drawer.dart';
import '../store/store_screen.dart';

class RatedBrandsScreen extends StatefulWidget {
  const RatedBrandsScreen({super.key, required this.brands});
  // final List<QueryDocumentSnapshot> brands;
  final List<BrandModel> brands;
  @override
  State<RatedBrandsScreen> createState() => _RatedBrandsScreenState();
}

class _RatedBrandsScreenState extends State<RatedBrandsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeControllerImp homeControllerImp = Get.put(HomeControllerImp());

  @override
  Widget build(BuildContext context) {
    print(widget.brands.length);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'VOLTEX',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Title
            const Text(
              'ALL rated brands',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Brand Grid
            Expanded(
              child: GridView.builder(
                itemCount: homeControllerImp.listBrands.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          homeControllerImp.brand =
                              widget.brands[index].BrandId;
                          homeControllerImp.subOrBrand();
                          homeControllerImp.update();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0.2),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: CustomImageWidget(
                              width: 80.w,
                              height: 70.h,
                              fit: BoxFit.fitWidth,
                              image:
                                  homeControllerImp.listBrands[index].imageUrl,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        homeControllerImp.listBrands[index].brandName,
                        style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.1,
                  mainAxisExtent: 120.h,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
