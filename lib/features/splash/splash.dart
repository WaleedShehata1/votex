// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/classes/app_usage_service.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../core/helper/route_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigatetohome();

    super.initState();
  }

  _navigatetohome() async {
    bool first = await AppUsageService.isFirstTime();

    bool isLogin = await AppUsageService.isLogin();
    print("object $first ");
    // if (!first) {
    //   if (!isLogin) {
    //     await Future.delayed(const Duration(seconds: 3), () {
    //       Get.offAllNamed(RouteHelper.signIn);
    //     });
    //   } else {
    //     await Future.delayed(const Duration(seconds: 3), () {
    //       // Get.offAllNamed(RouteHelper.homePage);
    //     });
    //   }
    // } else {
    //   await Future.delayed(const Duration(seconds: 3), () {
    //     // Get.offAllNamed(RouteHelper.lang);
    //   });
    // }
    await Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(RouteHelper.signIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        color: AppColors.backGroundSplash,
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            Image.asset(Images.logo2)
          ],
        ),
      ),
    ));
  }
}
