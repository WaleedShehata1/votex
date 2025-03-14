// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/classes/status_request.dart';
import '../../core/helper/route_helper.dart';
import '../../core/model/auth_eesponse.dart';

abstract class SignUpController extends GetxController {
  goToSignIn();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController NameController;
  late TextEditingController EmailController;
  late TextEditingController PasswordController;
  late TextEditingController ConfirmPassword;
  late TextEditingController rePasswordController;

  late PageController pageController;
  late TextEditingController searchController;

  User? userAuth;
  List data = [];

  SignUpControllerImp();
  late StatusRequest statusRequest;

  @override
  goToSignIn() {
    Get.offNamed(RouteHelper.signIn);
  }

  @override
  void onInit() {
    pageController = PageController();
    EmailController = TextEditingController();
    PasswordController = TextEditingController();
    rePasswordController = TextEditingController();
    ConfirmPassword = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    ConfirmPassword.dispose();
    rePasswordController.dispose();
    super.dispose();
  }
}
