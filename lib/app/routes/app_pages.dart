import 'package:demo_project/app/features/artiset/binding/artist_binding.dart';
import 'package:demo_project/app/features/artiset/view/artist_tunings_page.dart';
import 'package:demo_project/app/features/bottomNavbar/binding/bottom_navbar_binding.dart';
import 'package:demo_project/app/features/bottomNavbar/view/bottom_navbar_screen.dart';
import 'package:demo_project/app/features/buildSetup/binding/build_setup_binding.dart';
import 'package:demo_project/app/features/buildSetup/view/build_setup_page.dart';
import 'package:demo_project/app/features/calculate/binding/calculate_binding.dart';
import 'package:demo_project/app/features/calculate/view/calculate_screen.dart';
import 'package:demo_project/app/features/emailVerify/binding/email_verify_binding.dart';
import 'package:demo_project/app/features/emailVerify/view/email_verify_screen.dart';
import 'package:demo_project/app/features/forget/bindings/forget_binding.dart';
import 'package:demo_project/app/features/forget/view/forget_screen.dart';
import 'package:demo_project/app/features/library/binding/library_binding.dart';
import 'package:demo_project/app/features/library/view/library_page.dart';
import 'package:demo_project/app/features/match/binding/match_your_binding.dart';
import 'package:demo_project/app/features/match/view/match_your_setup_page.dart';
import 'package:demo_project/app/features/otpVerify/binding/otp_verify_binding.dart';
import 'package:demo_project/app/features/otpVerify/view/otp_verify_screen.dart';
import 'package:demo_project/app/features/profile/binding/profile_binding.dart';
import 'package:demo_project/app/features/profile/view/profile_page.dart';
import 'package:demo_project/app/features/resetPassword/binding/reset_password_binding.dart';
import 'package:demo_project/app/features/resetPassword/view/reset_password_screen.dart';
import 'package:demo_project/app/features/shop/binding/shop_binding.dart';
import 'package:demo_project/app/features/shop/view/shop_page.dart';
import 'package:demo_project/app/features/shopSetup/binding/shop_setup_binding.dart';
import 'package:demo_project/app/features/shopSetup/view/show_setup_page.dart';
import 'package:demo_project/app/features/singup/binding/signup_binding.dart';
import 'package:demo_project/app/features/singup/view/signup_screen.dart';
import 'package:demo_project/app/features/splash/binding/splash_binding.dart';
import 'package:demo_project/app/features/splash/view/splash_screen.dart';
import 'package:get/get.dart';

import 'package:demo_project/app/features/login/binding/login_binding.dart';
import 'package:demo_project/app/features/login/view/login_page.dart';
import 'package:demo_project/app/features/products/binding/products_binding.dart';
import 'package:demo_project/app/features/products/view/products_page.dart';
import 'package:demo_project/app/features/user_list/binding/user_list_binding.dart';
import 'package:demo_project/app/features/user_list/view/user_list_page.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:demo_project/app/routes/auth_middleware.dart';

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
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forget,
      page: () => const ForgetScreen(),
      binding: ForgetBinding(),
    ),
    GetPage(
      name: AppRoutes.otpVerify,
      page: () => OtpVerifyScreen(),
      binding: OtpVerifyBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerify,
      page: () => EmailVerifyScreen(),
      binding: EmailVerifyBinding(),
    ),
    GetPage(
      name: AppRoutes.bottomNavbar,
      page: () => BottomNavbarScreen(),
      binding: BottomNavbarBinding(),
    ),
    GetPage(
      name: AppRoutes.calculate,
      page: () => CalculateScreen(),
      binding: CalculateBinding(),
    ),
    GetPage(
      name: AppRoutes.matchYourSetup,
      page: () => MatchYourSetupPage(),
      binding: MatchYourBinding(),
    ),
    GetPage(
      name: AppRoutes.buildSetup,
      page: () => BuildSetupPage(),
      binding: BuildSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.shopSetup,
      page: () => ShowSetupPage(),
      binding: ShopSetupBinding(),
    ),

    GetPage(
      name: AppRoutes.artistTunings,
      page: () => ArtistTuningsPage(),
      binding: ArtistBinding(),
    ),
    GetPage(
      name: AppRoutes.library,
      page: () => LibraryPage(),
      binding: LibraryBinding(),
    ),
    GetPage(
      name: AppRoutes.shopPage,
      page: () => ShopPage(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: AppRoutes.profilePage,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.userList,
      page: () => const UserListPage(),
      binding: UserListBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductsPage(),
      binding: ProductsBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
