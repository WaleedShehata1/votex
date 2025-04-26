import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/auth/login.controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/styles.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/widget/custom_button.dart';
import '../../../core/widget/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<LoginControllerImp>(
        builder: (loginControllerImp) {
          return Scaffold(
            body: Form(
              key: loginControllerImp.formstate,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10.h),
                        Image.asset(Images.logo2, width: 141.w, height: 132.h),
                        const SizedBox(height: 20),
                        Text(
                          'Login',
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeOverLarge,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'VOLTEX',
                              style: robotoBold.copyWith(
                                color: AppColors.colorFont,
                                fontSize: Dimensions.fontSizeExtraLarge2,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Welcome to',
                              style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '--HOME APPLIANCE--',
                          style: robotoRegular.copyWith(
                            color: AppColors.colorFont2,
                            fontSize: Dimensions.fontSizeExtraLarge2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Email',
                          inputType: TextInputType.emailAddress,
                          borderRadius: Dimensions.radiusLarge,
                          controller: loginControllerImp.email,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: 'Password',
                          isPassword: true,
                          borderRadius: Dimensions.radiusLarge,
                          controller: loginControllerImp.password,
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          onPressed: () {
                            // Get.toNamed(RouteHelper.homePage);
                            loginControllerImp.signIn();
                          },
                          buttonText: 'Login',
                          color: Colors.transparent,
                          boarderColor: AppColors.colorFont,
                          textColor: AppColors.colorFont,
                          radius: Dimensions.paddingSizeExtraLarge,
                          width: 164.w,
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          onPressed: () {
                            Get.toNamed(RouteHelper.forgetPassword);
                          },
                          buttonText:
                              '?'
                                      ' Password Forgotten'
                                  .tr,
                          width: 170.w,
                          height: 30,
                          color: Colors.transparent,
                          fontSize: Dimensions.fontSizeDefault,
                          textColor: AppColors.colorFont,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              onPressed: () {
                                Get.toNamed(RouteHelper.signUp);
                              },
                              buttonText: 'Signup'.tr,
                              width: 55.w,
                              height: 30,
                              color: Colors.transparent,
                              textColor: AppColors.colorFont3,
                            ),
                            Text(
                              "?"
                                      "Don't have an account"
                                  .tr,
                              style: robotoBold.copyWith(
                                color: AppColors.colorFont,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Or login with',
                          style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge,
                            color: AppColors.colorFont3,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.colorFont),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // loginControllerImp.signInWithFacebook();
                                },
                                child: Image.asset(Images.facebookIcon),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              padding: const EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.colorFont),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  loginControllerImp.signInWithGoogle();
                                },
                                child: Image.asset(Images.googleIcon),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
