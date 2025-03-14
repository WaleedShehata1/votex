import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/classes/status_request.dart';
import '../../core/helper/route_helper.dart';
import '../../features/auth/forget_password/forget_password.dart';

abstract class LoginController extends GetxController {
  // login();
//signOut();
  goToSignUp();
  goToForgetPassword();
  // signInWithGoogle();
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

//   @override
//   Future signInWithGoogle() async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication? googleAuth =
//     await googleUser?.authentication;

//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );

//     // Once signed in, return the UserCredential
// //return await FirebaseAuth.instance.signInWithCredential(credential);
//     await FirebaseAuth.instance.signInWithCredential(credential);

//     PreferenceUtils.setIsOwner(AppConstants.isUser);
//     Get.toNamed(RouteHelper.dashboard);
//   }

//   @override
//   Future<void> signInWithFacebook() async {
//     try {
//       final LoginResult loginResult = await FacebookAuth.instance.login();

//       if (loginResult.status == LoginStatus.success) {
//         final AccessToken accessToken = loginResult.accessToken!;
//         final OAuthCredential facebookAuthCredential =
//         FacebookAuthProvider.credential(accessToken.tokenString);

//         await FirebaseAuth.instance
//             .signInWithCredential(facebookAuthCredential);
//         PreferenceUtils.setIsOwner(AppConstants.isUser);
//         Get.toNamed(RouteHelper.dashboard);
//       } else {
//         print("Login failed: ${loginResult.message}");
//       }
//     } on Exception catch (e) {
//       print("FacebookAuthException: ${e}");
//     } catch (e) {
//       print("General error: ${e.toString()}");
//     }
//   }

  // @override
  // signOut() async {
  //   GoogleSignIn? googleSignIn = GoogleSignIn();
  //   googleSignIn.disconnect();
  //   FacebookAuth.instance.logOut();
  //   Get.toNamed(AppRoutes.loginScreen);
  // }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToForgetPassword() {
    Get.to(ForgetPassword());
  }
}
