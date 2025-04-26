// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:voltex/core/model/user_model.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/classes/status_request.dart';
import '../../core/functions/checkInternet.dart';
import '../../core/helper/route_helper.dart';
import '../../core/widget/custom_snackbar.dart';
import '../notification/notification_controller.dart';

abstract class SignUpController extends GetxController {
  goToSignIn();
  signInWithGoogle();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController rePasswordController;
  late PageController pageController;
  late TextEditingController searchController;
  var isLoadingSignUpWithEmail = false.obs;
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );
  // User? userAuth;
  List data = [];
  var googleSignIn = GoogleSignIn();
  var displayUserName = '';
  var displayUserPhoto = '';
  var displayUserEmail = '';
  // static const List<String> scopes = <String>[
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ];
  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   // Optional clientId
  //   // clientId: 'your-client_id.apps.googleusercontent.com',
  //   scopes: scopes,
  // );
  SignUpControllerImp();
  late StatusRequest statusRequest;

  final firebase = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // @override
  // Future signInWithGoogle() async {
  //   // try {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   displayUserName = googleUser!.displayName!;
  //   displayUserPhoto = googleUser.photoUrl!;
  //   displayUserEmail = googleUser.email;
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //     // UserCreate(uid: googleUser.id);
  //     print("object ${googleUser.id}");
  //     // Get.offNamed(RouteHelper.homeScreen);

  //     showCustomSnackBar('Account registration succeeded'.tr, isError: false);
  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (error) {
  //     print("err ${error.toString()}");
  //     showCustomSnackBar(error.toString(), isError: true);
  //   }
  //   // Get.toNamed(RouteHelper.homeScreen);
  // }

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
      await AppUsageService.saveToken(googleAuth?.accessToken.toString() ?? '');
      String userId = userCredential.user!.uid;
      String userName = googleUser.displayName!;
      String userEmail = googleUser.email;
      UserCreate2(
        uid: UserModel(
          uid: userId,
          tokenDevice: notificationController.fcmToken.value,
          userName: userName,
          phone: '',
          email: userEmail,
        ),
      );
      // if (userId.length <= 10) {
      //   await AppUsageService.saveUserId(userId);
      // } else {
      //   await AppUsageService.saveUserId('0');
      // }
      // await AppUsageService.saveUserName(googleUser.displayName ?? '');
      // await AppUsageService.saveUserEmail(googleUser.email);
      // await AppUsageService.saveLogin(true);
    }

    print('googleUser.id ${googleUser!.id}');
    print(
      'googleAuth?.accessToken.toString() ${googleAuth?.accessToken.toString()}',
    );
    print('googleUser.displayName ${googleUser.displayName}');
    print('googleUser.email ${googleUser.email}');
    print('googleUser.displayName ${googleUser.photoUrl}');
    print('googleUser.displayName ${googleUser}');
    // Get.toNamed(RouteHelper.dashboard);
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        await FirebaseAuth.instance.signInWithCredential(
          facebookAuthCredential,
        );

        // Get.toNamed(RouteHelper.dashboard);
      } else {
        print("Login failed: ${loginResult.message}");
      }
    } on Exception catch (e) {
      print("FacebookAuthException: $e");
    } catch (e) {
      print("General error: ${e.toString()}");
    }
  }

  Future<void> SignUp() async {
    if (formstate.currentState!.validate()) {
      isLoadingSignUpWithEmail = true.obs;
      if (await CheckInternet.checkInternet()) {
        OverlayLoadingProgress.start();
        try {
          var response = await firebase
              .createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              )
              .then((value) async {
                UserCreate(uid: value.user!.uid);
              });
          showCustomSnackBar(
            'Account registration succeeded'.tr,
            isError: false,
          );

          OverlayLoadingProgress.stop();
          Get.back();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showCustomSnackBar(
              'The password provided is too weak.',
              isError: true,
            );
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            showCustomSnackBar(
              'The account already exists for that email.',
              isError: true,
            );
            print('The account already exists for that email.');
          }
          showCustomSnackBar(e.toString(), isError: true);
          print('The account $e.code}.');
          isLoadingSignUpWithEmail = false.obs;
        }
        OverlayLoadingProgress.stop();
      } else {
        OverlayLoadingProgress.stop();
        isLoadingSignUpWithEmail = false.obs;
        showCustomSnackBar('Check the internet connection'.tr, isError: true);
      }
    }
  }

  UserCreate({required String uid}) async {
    UserModel model = UserModel(
      userName: nameController.text,
      phone: phoneController.text,
      tokenDevice: notificationController.fcmToken.value,
      email: emailController.text,
      uid: uid,
      address: '',
    );
    users
        .doc(uid)
        .set(model.toFireStore())
        .then((value) {
          AppUsageService.saveUserId(uid);
          update();
        })
        .catchError((error) {
          showCustomSnackBar(error, isError: true);
        });
  }

  UserCreate2({required UserModel uid}) async {
    users
        .doc(uid.uid)
        .set(uid.toFireStore())
        .then((value) {
          AppUsageService.saveUserId(uid.uid);
          AppUsageService.saveUserEmail(uid.email);
          AppUsageService.saveUserName(uid.userName);
          showCustomSnackBar(
            'Account registration succeeded'.tr,
            isError: false,
          );
          Get.back();
          update();
        })
        .catchError((error) {
          showCustomSnackBar(error, isError: true);
        });
  }

  @override
  goToSignIn() {
    Get.offNamed(RouteHelper.signIn);
  }

  @override
  void onInit() {
    pageController = PageController();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    phoneController = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }
}
