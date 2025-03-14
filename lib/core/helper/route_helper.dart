import 'package:get/get.dart';
import '../../features/auth/forget_password/forget_password.dart';
import '../../features/auth/forget_password/successfully.dart';
import '../../features/auth/signin/sign_in_screen.dart';
import '../../features/auth/forget_password/check_your_email.dart';
import '../../features/auth/signup/sign_up_screen.dart';
import '../../features/home/home_page.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/widget/special_offer_section.dart';
import '../../features/lang/lang_screen.dart';
import '../../features/offers/offers_screen.dart';
import '../../features/order/order_screen.dart';
import '../../features/product/proudct_details_screen.dart';
import '../../features/rated brand/all_rated_brands.dart';
import '../../features/splash/splash.dart';

class RouteHelper {
  static const String initial = '/';
  static const String lang = '/LangScreen';
  static const String signIn = '/SignInScreen';
  static const String signUp = '/SignUpScreen';
  static const String forgetPassword = '/ForgetPassword';
  static const String checkYourEmail = '/CheckYourEmail';
  static const String passwordUpdatedScreen = '/PasswordUpdatedScreen';
  static const String homeScreen = '/HomeScreen';
  static const String homePage = '/HomePage';
  static const String ordersScreen = '/OrdersScreen';
  static const String specialOfferScreen = '/SpecialOfferScreen';
  static const String ratedBrandsScreen = '/RatedBrandsScreen';
  static const String specialOfferSection = '/SpecialOfferSection';
  static const String productDetailsScreen = '/ProductDetailsScreen';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(name: lang, page: () => const LangScreen()),
    GetPage(name: signIn, page: () => LoginScreen()),
    GetPage(name: signUp, page: () => SignupScreen()),
    GetPage(name: forgetPassword, page: () => ForgetPassword()),
    GetPage(name: checkYourEmail, page: () => CheckYourEmail()),
    GetPage(name: passwordUpdatedScreen, page: () => PasswordUpdatedScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: homePage, page: () => const HomePage()),
    GetPage(name: ordersScreen, page: () => const OrderScreen()),
    GetPage(name: specialOfferScreen, page: () => const SpecialOfferScreen()),
    GetPage(name: ratedBrandsScreen, page: () => const RatedBrandsScreen()),
    GetPage(name: specialOfferSection, page: () => const SpecialOfferSection()),
    GetPage(
        name: productDetailsScreen, page: () => const ProductDetailsScreen()),
  ];
}
