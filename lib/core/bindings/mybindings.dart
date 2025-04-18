import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votex/controller/cart/cart_controller.dart';

import '../../controller/account/account_controller.dart';
import '../../controller/auth/forgetpassword.controller.dart';
import '../../controller/auth/login.controller.dart';
import '../../controller/auth/resetpassword.controller.dart';
import '../../controller/auth/signupController.dart';
import '../../controller/contact/contact_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/product/product_controller.dart';
import '../../controller/saved/saved_controller.dart';

class Mybinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<SharedPreferences>(
        () async => await SharedPreferences.getInstance(),
        permanent: true);

    Get.lazyPut(() => LoginControllerImp(), fenix: true);
    Get.lazyPut(() => ForgetPasswordControllerImp(), fenix: true);
    Get.lazyPut(() => ResetPasswordControllerImp(), fenix: true);
    Get.lazyPut(() => SignUpControllerImp(), fenix: true);
    Get.lazyPut(() => HomeControllerImp(), fenix: true);
    Get.lazyPut(() => SavedControllerImp(), fenix: true);
    Get.lazyPut(() => CartControllerImp(), fenix: true);
    Get.lazyPut(() => AccountControllerImp(), fenix: true);
    Get.lazyPut(() => ContactController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
  }
}
