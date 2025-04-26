import 'package:get/get.dart';
import '../../features/about us/about_us_screen.dart';
import '../../features/auth/forget_password/forget_password.dart';
import '../../features/auth/forget_password/successfully.dart';
import '../../features/auth/signin/sign_in_screen.dart';
import '../../features/auth/forget_password/check_your_email.dart';
import '../../features/auth/signup/sign_up_screen.dart';
import '../../features/home/home_page.dart';
import '../../features/home/home_screen.dart';
import '../../features/lang/lang_screen.dart';
import '../../features/notification/notification_screen.dart';
import '../../features/offers/offers_screen.dart';
import '../../features/order/order_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/sensor/add_sensor_screen.dart';
import '../../features/setting/setting_screen.dart';
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
  static const String profileScreen = '/ProfileScreen';
  static const String notificationsScreen = '/NotificationsScreen';
  static const String settingsScreen = '/SettingsScreen';
  static const String addSensorScreen = '/AddSensorScreen';
  static const String aboutUsScreen = '/AboutUsScreen';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(name: lang, page: () => const LangScreen()),
    GetPage(name: signIn, page: () => const LoginScreen()),
    GetPage(name: signUp, page: () => const SignupScreen()),
    GetPage(name: forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: checkYourEmail, page: () => CheckYourEmail()),
    GetPage(
      name: passwordUpdatedScreen,
      page: () => const PasswordUpdatedScreen(),
    ),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: homePage, page: () => const HomePage()),
    GetPage(name: ordersScreen, page: () => const OrderScreen()),
    // GetPage(name: specialOfferScreen, page: () => const SpecialOfferScreen()),
    // GetPage(name: ratedBrandsScreen, page: () => const RatedBrandsScreen()),
    // GetPage(name: specialOfferSection, page: () => const SpecialOfferSection()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: notificationsScreen, page: () => const NotificationsScreen()),
    // GetPage(
    //     name: productDetailsScreen, page: () => const ProductDetailsScreen()),
    GetPage(name: settingsScreen, page: () => const SettingsScreen()),
    GetPage(name: addSensorScreen, page: () => const AddSensorScreen()),
    GetPage(name: aboutUsScreen, page: () => const AboutUsScreen()),
  ];
}
