// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voltex/core/classes/app_usage_service.dart';
import '../../core/functions/checkInternet.dart';
import '../../core/helper/route_helper.dart';
import '../../core/model/user_model.dart';
import '../../core/widget/custom_snackbar.dart';
import '../../features/auth/forget_password/forget_password.dart';
import '../notification/notification_controller.dart';

abstract class LoginController extends GetxController {
  // login();
  //signOut();
  goToSignUp();
  goToForgetPassword();
  signInWithGoogle();
  // signInWithFacebook();
}

class LoginControllerImp extends LoginController {
  final users = FirebaseFirestore.instance.collection('users');
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  LoginControllerImp();
  UserModel? model;
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

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

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    if (googleUser != null) {
      // await AppUsageService.saveToken(googleAuth?.accessToken.toString() ?? '');
      await users.doc(userCredential.user!.uid).get().then((
        DocumentSnapshot documentSnapshot,
      ) {
        if (documentSnapshot.exists) {
          model = UserModel.fromFirestore(documentSnapshot);
          print(model!.userName);
          Get.offNamed(RouteHelper.homePage);
        } else {
          showCustomSnackBar('You must register first'.tr, isError: true);
        }
        print(documentSnapshot.id);
      });
    }
  }

  Future<void> signIn() async {
    if (formstate.currentState!.validate()) {
      if (await CheckInternet.checkInternet()) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
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

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  model = UserModel.fromFirestore(documentSnapshot);
                  AppUsageService.saveUserName(model!.userName);
                }
                print(documentSnapshot.exists);
              });
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .update({'tokenDevice': notificationController.fcmToken.value})
              .then((value) => print('done'))
              .catchError((error) => print("Failed to update user: $error"));

          print("Login successful!");
          showCustomSnackBar("Login successful!", isError: false);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
            showCustomSnackBar('No user found for that email.', isError: true);
          } else if (e.code == 'wrong-password') {
            showCustomSnackBar(
              'Wrong password provided for that user.',
              isError: true,
            );
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

  signOut() async {
    GoogleSignIn? googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
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
