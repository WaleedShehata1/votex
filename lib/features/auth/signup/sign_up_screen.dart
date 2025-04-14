import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/auth/signupController.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/styles.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/widget/custom_button.dart';
import '../../../core/widget/custom_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpControllerImp>(
      builder: (signUpControllerImp) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: signUpControllerImp.formstate,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.logo2,
                        width: 141.w,
                        height: 132.h,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Full Name',
                        borderRadius: Dimensions.radiusLarge,
                        controller: signUpControllerImp.nameController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Email',
                        inputType: TextInputType.emailAddress,
                        borderRadius: Dimensions.radiusLarge,
                        controller: signUpControllerImp.emailController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Mobile Phone',
                        inputType: TextInputType.number,
                        borderRadius: Dimensions.radiusLarge,
                        controller: signUpControllerImp.phoneController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Your Password',
                        isPassword: true,
                        borderRadius: Dimensions.radiusLarge,
                        controller: signUpControllerImp.passwordController,
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      CustomButton(
                        onPressed: () {
                          signUpControllerImp.SignUp();
                        },
                        buttonText: 'Signup',
                        boarderColor: AppColors.colorFont,
                        textColor: Colors.white,
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(Dimensions.radiusLarge),
                          bottomEnd: Radius.circular(Dimensions.radiusLarge),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            onPressed: () {
                              Get.toNamed(RouteHelper.signIn);
                            },
                            buttonText: 'Login'.tr,
                            width: 50,
                            height: 30,
                            color: Colors.transparent,
                            textColor: AppColors.colorFont3,
                          ),
                          Text(
                            "?" "Don't have an account".tr,
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
                            color: AppColors.colorFont3),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.colorFont),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusExtraLarge)),
                            child: GestureDetector(
                                onTap: () {
                                  signUpControllerImp.signInWithFacebook();
                                },
                                child: Image.asset(Images.facebookIcon)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.colorFont),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusExtraLarge)),
                            child: GestureDetector(
                                onTap: () {
                                  signUpControllerImp.signInWithGoogle();
                                },
                                child: Image.asset(Images.googleIcon)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
