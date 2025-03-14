import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/constants/images.dart';
import '../../core/constants/styles.dart';
import '../../core/widget/custom_text_field.dart';
import 'widget/categories_section.dart';
import 'widget/premium_home_banner.dart';
import 'widget/special_offer_section.dart';
import 'widget/top_rated_brands.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                  child: SvgPicture.asset(
                    Images.backgroundAppBar,
                    height: 210.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                  offset: const Offset(-20, 110),
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
              height: 14.h,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.63,
              child: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    TopRatedBrands(),
                    SizedBox(height: 10),
                    PremiumHomeBanner(),
                    SizedBox(height: 10),
                    SpecialOfferSection(),
                    SizedBox(height: 25),
                    CategoriesSection(),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
