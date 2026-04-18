import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  onInit() {
    super.onInit();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = StorageService().getToken();

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.bottomNavbar);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
