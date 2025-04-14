import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
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
                shrinkWrap: true,
                itemCount: widget.brands.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(ProductListScreen(
                          brand: widget.brands[index].BrandId,
                        )),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 32,
                          child: CustomImageWidget(
                            image: widget.brands[index].imageUrl,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.brands[index].brandName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }

  // Function to build a single row of brands
  // Widget _buildBrandRow(List<BrandModel> brands) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 15),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: brands
  //           .map(
  //             (brand) => Column(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => Get.to(ProductListScreen(
  //                     brand: brand.BrandId,
  //                   )),
  //                   child: CircleAvatar(
  //                     backgroundColor: Colors.white,
  //                     radius: 30,
  //                     backgroundImage: AssetImage(brand.imageUrl!),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Text(
  //                   brand.brandName!,
  //                   style: const TextStyle(fontSize: 14),
  //                 ),
  //               ],
  //             ),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }
}
