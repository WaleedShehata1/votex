// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:votex/core/model/user_model.dart';
import '../../core/classes/app_usage_service.dart';
import '../../core/classes/status_request.dart';
import '../../core/functions/checkInternet.dart';
import '../../core/helper/route_helper.dart';
import '../../core/widget/custom_snackbar.dart';

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
  Future<UserCredential> signInWithGoogle() async {
    print('object');
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    print('object');
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    print('object0');
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print('object1');
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithFacebook() async {
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
      print("FacebookAuthException: ${e}");
    } catch (e) {
      print("General error: ${e.toString()}");
    }
  }

  Future<void> SignUp() async {
    if (formstate.currentState!.validate()) {
      isLoadingSignUpWithEmail = true.obs;
      if (await CheckInternet.checkInternet()) {
        try {
          var response = await firebase
              .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
              .then((value) async {
            UserCreate(uid: value.user!.uid);
          });
          showCustomSnackBar('Account registration succeeded'.tr,
              isError: false);
          Get.offNamed(RouteHelper.signIn);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showCustomSnackBar('The password provided is too weak.',
                isError: true);
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            showCustomSnackBar('The account already exists for that email.',
                isError: true);
            print('The account already exists for that email.');
          }
          showCustomSnackBar(e.toString(), isError: true);
          print('The account $e.code}.');
          isLoadingSignUpWithEmail = false.obs;
        }
      } else {
        isLoadingSignUpWithEmail = false.obs;
        showCustomSnackBar('Check the internet connection'.tr, isError: true);
      }
    }
  }

  UserCreate({required String uid}) async {
    UserModel model = UserModel(
      userName: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      uid: uid,
    );
    users.doc(uid).set(model.toFireStore()).then((value) {
      AppUsageService.saveUserId(uid);
      update();
    }).catchError((error) {
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
