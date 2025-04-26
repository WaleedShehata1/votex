import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/auth/forgetpassword.controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/styles.dart';
import '../../../core/helper/route_helper.dart';
import '../signin/sign_in_screen.dart';

class CheckYourEmail extends StatelessWidget {
  CheckYourEmail({super.key});
  final ForgetPasswordControllerImp controller = Get.put(
    ForgetPasswordControllerImp(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Check Your Email",
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeOverLarge2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We have sent the reset password to the email address",
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: AppColors.colorFont2,
              ),
            ),
            Text(
              controller.email.text,
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: AppColors.colorFont2,
              ),
            ),
            const SizedBox(height: 20),
            SvgPicture.asset(
              Images.checkYourEmail, // Add your SVG asset path here
              height: 150,
            ),
            const SizedBox(height: 30),
            Text(""),
            // ElevatedButton(
            //   onPressed: () {
            //     Get.toNamed(RouteHelper.passwordUpdatedScreen);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.colorFont,
            //     minimumSize: const Size(double.infinity, 50),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: const Text(
            //     "OPEN YOUR EMAIL",
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.to(LoginScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 168, 216, 255),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "BACK TO LOGIN",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    controller.sendEmailVerificationLink();
                    controller.update();
                  },
                  child: const Text(
                    "Resend",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "?"
                          " You have not received the email"
                      .tr,
                  style: robotoRegular.copyWith(
                    color: AppColors.colorFont3,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
