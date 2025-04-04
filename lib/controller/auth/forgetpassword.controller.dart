import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/classes/status_request.dart';

abstract class ForgetPasswordController extends GetxController {}

class ForgetPasswordControllerImp extends ForgetPasswordController {
  ForgetPasswordControllerImp();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  GlobalKey<FormState> formstate2 = GlobalKey<FormState>();
  late PageController pageController;
  late TextEditingController email;
  late StatusRequest statusRequest;
  int countdown = 50;
  late Timer timer;
  bool canResend = false;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (countdown > 0) {
        countdown--;
        update();
      } else {
        canResend = true;
        t.cancel();
        update();
      }
    });
  }

  // isLog() async {
  //   await PreferenceUtils.setLogin(true);
  // }

  @override
  void onInit() {
    pageController = PageController();
    email = TextEditingController();
    startTimer();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    timer.cancel();
    super.dispose();
  }
}
