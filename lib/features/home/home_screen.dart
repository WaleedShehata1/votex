import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controller/home/home_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/images.dart';
import '../../core/constants/styles.dart';
import '../../core/widget/custom_text_field.dart';
import '../rated brand/all_rated_brands.dart';
import 'widget/brand_circle.dart';
import 'widget/categories_section.dart';
import 'widget/premium_home_banner.dart';
import 'widget/special_offer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.load();
          controller.update();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(
                        50,
                      ),
                      bottomStart: Radius.circular(
                        50,
                      ),
                    ),
                    child: SizedBox(
                      height: 160.h,
                      width: double.infinity,
                      child: SvgPicture.asset(
                        Images.backgroundAppBar,
                        height: 160.h,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: Dimensions.paddingSizeLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(Images.userIcon),
                            const Row(
                              children: [
                                Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Hi, Mohamed',
                          style: robotoBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeOverLarge,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Welcome to ',
                              style: robotoRegular.copyWith(
                                color: Colors.white,
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                            Text(
                              'VOLTEX',
                              style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                            Text(
                              ' Electrical',
                              style: robotoRegular.copyWith(
                                color: Colors.white,
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Appliances Store',
                          style: robotoRegular.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        controller.localizationController.locale.languageCode ==
                                'ar'
                            ? -20
                            : 20,
                        95),
                    child: CustomTextField(
                      colorFill: Colors.white,
                      hintText: 'Search here',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 25.w,
                        color: AppColors.colorFont3,
                      ),
                      borderRadius: Dimensions.radiusExtraLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 22.h,
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height * 0.517).h,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Top rated brands',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(RatedBrandsScreen(
                                    brands: controller.listBrands,
                                  )),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'See All',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CircleAvatar(
                                        maxRadius: 15,
                                        backgroundColor: Colors.blue,
                                        child:
                                            Icon(Icons.arrow_forward_rounded),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 120,
                              width: double.maxFinite,
                              child: controller.listBrands.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.listBrands.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              mainAxisExtent: 90),
                                      itemBuilder: (context, i) {
                                        return GestureDetector(
                                          onTap: () {
                                            controller.brand = controller
                                                .listBrands[i].BrandId;
                                            controller.subOrBrand();
                                            controller.update();
                                          },
                                          child: BrandCircle(
                                            brand: controller
                                                .listBrands[i].brandName,
                                            image: controller
                                                .listBrands[i].imageUrl,
                                          ),
                                        );
                                      }),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const PremiumHomeBanner(),
                      const SizedBox(height: 10),
                      controller.listItem.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SpecialOfferSection(
                              listItems: controller.listItem,
                              listItemsOffer: controller.listItemOffer,
                            ),
                      const SizedBox(height: 30),
                      controller.listSubCategoryes.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CategoriesSection(
                              listSubCategoryes: controller.listSubCategoryes,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
