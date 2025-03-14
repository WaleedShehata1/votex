import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/styles.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/widget/custom_text_field.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

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
                  '?' 'Forgot Password',
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'To reset your password, you need your email or mobile number that can be authenticated',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: AppColors.colorFont2),
                ),
                const SizedBox(height: 5),

                SvgPicture.asset(
                  Images.forgetPassword,
                  height: 150,
                ), // Replace with actual asset
                const SizedBox(height: 20),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "Email".tr,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ),
                CustomTextField(
                  hintText: 'VOLTEX@gmail.com',
                  borderRadius: Dimensions.radiusDefault,
                  colorBorder: AppColors.colorFont3,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.checkYourEmail);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorFont,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Reset Password',
                      style: TextStyle(color: Colors.white)),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
