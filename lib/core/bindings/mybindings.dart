import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth/forgetpassword.controller.dart';
import '../../controller/auth/login.controller.dart';
import '../../controller/auth/resetpassword.controller.dart';
import '../../controller/auth/signupController.dart';

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
  }
}
