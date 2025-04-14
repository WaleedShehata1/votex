// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:votex/core/classes/app_usage_service.dart';
import '../../core/classes/status_request.dart';
import '../../core/functions/checkInternet.dart';
import '../../core/helper/route_helper.dart';
import '../../core/widget/custom_snackbar.dart';
import '../../features/auth/forget_password/forget_password.dart';

abstract class LoginController extends GetxController {
  // login();
//signOut();
  goToSignUp();
  goToForgetPassword();
  signInWithGoogle();
  // signInWithFacebook();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  LoginControllerImp();

  late StatusRequest statusRequest;

  @override
  goToSignUp() {
    Get.offNamed(RouteHelper.signUp);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (googleUser != null) {
      await AppUsageService.saveToken(googleAuth?.accessToken.toString() ?? '');
      String userId = googleUser.id;
      // if (userId.length <= 10) {
      //   await AppUsageService.saveUserId(userId);
      // } else {
      //   await AppUsageService.saveUserId('0');
      // }
      await AppUsageService.saveUserName(googleUser.displayName ?? '');
      await AppUsageService.saveUserEmail(googleUser.email);
      await AppUsageService.saveLogin(true);
    }

    print('googleUser.id ${googleUser!.id}');
    print(
        'googleAuth?.accessToken.toString() ${googleAuth?.accessToken.toString()}');
    print('googleUser.displayName ${googleUser.displayName}');
    // Get.toNamed(RouteHelper.dashboard);
  }

  Future<void> signInWithFacebook() async {
    if (await CheckInternet.checkInternet()) {
      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();

        if (loginResult.status == LoginStatus.success) {
          final AccessToken accessToken = loginResult.accessToken!;
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          // Get.toNamed(RouteHelper.dashboard);
        } else {
          print("Login failed: ${loginResult.message}");
        }
      } on Exception catch (e) {
        print("FacebookAuthException: $e");
      } catch (e) {
        print("General error: ${e.toString()}");
      }
    } else {
      showCustomSnackBar('Check the internet connection'.tr, isError: true);
    }
  }

  Future<void> signIn() async {
    if (formstate.currentState!.validate()) {
      if (await CheckInternet.checkInternet()) {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );

          if (!userCredential.user!.emailVerified) {
            print("Email not verified. Please check your inbox.");
            await userCredential.user!.sendEmailVerification();
          }
          Get.toNamed(RouteHelper.homePage);
          print("object ${userCredential.user!.uid}");
          AppUsageService.saveUserId(userCredential.user!.uid);
          print("Login successful!");
          showCustomSnackBar("Login successful!", isError: false);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
            showCustomSnackBar('No user found for that email.', isError: true);
          } else if (e.code == 'wrong-password') {
            showCustomSnackBar('Wrong password provided for that user.',
                isError: true);
            print('Wrong password provided for that user.');
          }

          print("err ${e.code.toString()}");

          showCustomSnackBar("Incorrect email or password", isError: true);
        }
      } else {
        showCustomSnackBar('Check the internet connection'.tr, isError: true);
      }
    }
  }

  @override
  signOut() async {
    GoogleSignIn? googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FacebookAuth.instance.logOut();
    Get.toNamed(RouteHelper.signIn);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToForgetPassword() {
    Get.to(const ForgetPassword());
  }
}
