import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:overlay_kit/overlay_kit.dart';

import '../../core/functions/checkInternet.dart';
import '../../core/widget/custom_snackbar.dart';

abstract class ResetPasswordController extends GetxController {
  resetpassword();
  goToSuccessResetPassword();
  goToLogin();
}

class ResetPasswordControllerImp extends ResetPasswordController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController password;
  late TextEditingController repassword;

  @override
  resetpassword() async {
    if (await CheckInternet.checkInternet()) {
      OverlayLoadingProgress.start();
      var formdata = formstate.currentState;
      if (password.text == repassword.text) {
        if (formdata!.validate()) {
          // print("Valid");
          OverlayLoadingProgress.stop();

          goToLogin();
        } else {
          //  print("Not Valid");
          OverlayLoadingProgress.stop();
        }
      } else {
        OverlayLoadingProgress.stop();
        showCustomSnackBar('errorRepassword'.tr, isError: true);
      }
    } else {
      OverlayLoadingProgress.stop();
      showCustomSnackBar('Check the internet connection'.tr, isError: true);
    }
  }

  @override
  goToSuccessResetPassword() {
    ///  Get.offNamed(AppRoutes.resetpassword);
  }

  @override
  goToLogin() {
    // Get.offAll(() => IntroLoginScreen());
  }

  @override
  void onInit() {
    password = TextEditingController();
    repassword = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    repassword.dispose();
    super.dispose();
  }
}
