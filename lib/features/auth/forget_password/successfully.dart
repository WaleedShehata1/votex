import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/styles.dart';
import '../../../core/helper/route_helper.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Successfully',
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your password has been updated, please change your password regularly to avoid this happening',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: AppColors.colorFont2),
                ),
                const SizedBox(height: 20),

                SvgPicture.asset(
                  Images.successfully,
                  height: 150,
                ), // Replace with actual asset
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.homeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorFont,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:
                      const Text('CONTINUE', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.signIn);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 168, 216, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('BACK TO LOGIN',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
