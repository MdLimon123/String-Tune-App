import 'package:does_it_doom/app/features/artiset/binding/artist_binding.dart';
import 'package:does_it_doom/app/features/artiset/view/artist_tunings_page.dart';
import 'package:does_it_doom/app/features/bottomNavbar/binding/bottom_navbar_binding.dart';
import 'package:does_it_doom/app/features/bottomNavbar/view/bottom_navbar_screen.dart';
import 'package:does_it_doom/app/features/buildSetup/binding/build_setup_binding.dart';
import 'package:does_it_doom/app/features/buildSetup/view/build_setup_page.dart';
import 'package:does_it_doom/app/features/calculate/binding/calculate_binding.dart';
import 'package:does_it_doom/app/features/calculate/view/calculate_screen.dart';
import 'package:does_it_doom/app/features/emailVerify/binding/email_verify_binding.dart';
import 'package:does_it_doom/app/features/emailVerify/view/email_verify_screen.dart';
import 'package:does_it_doom/app/features/forget/bindings/forget_binding.dart';
import 'package:does_it_doom/app/features/forget/view/forget_screen.dart';
import 'package:does_it_doom/app/features/library/binding/library_binding.dart';
import 'package:does_it_doom/app/features/library/view/library_page.dart';
import 'package:does_it_doom/app/features/match/binding/match_your_binding.dart';
import 'package:does_it_doom/app/features/match/view/match_your_setup_page.dart';
import 'package:does_it_doom/app/features/otpVerify/binding/otp_verify_binding.dart';
import 'package:does_it_doom/app/features/otpVerify/view/otp_verify_screen.dart';
import 'package:does_it_doom/app/features/profile/binding/profile_binding.dart';
import 'package:does_it_doom/app/features/profile/view/profile_page.dart';
import 'package:does_it_doom/app/features/resetPassword/binding/reset_password_binding.dart';
import 'package:does_it_doom/app/features/resetPassword/view/reset_password_screen.dart';
import 'package:does_it_doom/app/features/shop/binding/shop_binding.dart';
import 'package:does_it_doom/app/features/shop/view/shop_page.dart';
import 'package:does_it_doom/app/features/shopSetup/binding/shop_setup_binding.dart';
import 'package:does_it_doom/app/features/shopSetup/view/show_setup_page.dart';
import 'package:does_it_doom/app/features/singup/binding/signup_binding.dart';
import 'package:does_it_doom/app/features/singup/view/signup_screen.dart';
import 'package:does_it_doom/app/features/splash/binding/splash_binding.dart';
import 'package:does_it_doom/app/features/splash/view/splash_screen.dart';
import 'package:get/get.dart';

import 'package:does_it_doom/app/features/login/binding/login_binding.dart';
import 'package:does_it_doom/app/features/login/view/login_page.dart';
import 'package:does_it_doom/app/routes/auth_middleware.dart';

import 'package:does_it_doom/app/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () =>  SignupScreen(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () =>  LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forget,
      page: () =>  ForgetScreen(),
      binding: ForgetBinding(),
    ),
    GetPage(
      name: AppRoutes.otpVerify,
      page: () => OtpVerifyScreen(email: Get.arguments['email']),
      binding: OtpVerifyBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerify,
      page: () => EmailVerifyScreen(email: Get.arguments['email']),
      binding: EmailVerifyBinding(),
    ),
    GetPage(
      name: AppRoutes.bottomNavbar,
      page: () => BottomNavbarScreen(),
      binding: BottomNavbarBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.calculate,
      page: () => CalculateScreen(),
      binding: CalculateBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.matchYourSetup,
      page: () => MatchYourSetupPage(),
      binding: MatchYourBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.buildSetup,
      page: () => BuildSetupPage(),
      binding: BuildSetupBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.shopSetup,
      page: () => ShowSetupPage(),
      binding: ShopSetupBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.artistTunings,
      page: () => ArtistTuningsPage(),
      binding: ArtistBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.library,
      page: () => LibraryPage(),
      binding: LibraryBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.shopPage,
      page: () => ShopPage(),
      binding: ShopBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profilePage,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
  
 
  ];
}
