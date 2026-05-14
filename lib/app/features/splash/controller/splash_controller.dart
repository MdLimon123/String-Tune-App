import 'package:does_it_doom/app/core/network/api_endpoints.dart';
import 'package:does_it_doom/app/core/network/api_exception.dart';
import 'package:does_it_doom/app/core/network/base_api_service.dart';
import 'package:does_it_doom/app/core/storage/storage_service.dart';
import 'package:does_it_doom/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  onInit() {
    super.onInit();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final storage = StorageService();
    final token = storage.getToken();

    if (token == null || token.isEmpty) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    try {
      await BaseApiService().get(
        ApiEndpoints.getProfile,
        timeout: const Duration(seconds: 15),
      );
      Get.offAllNamed(AppRoutes.bottomNavbar);
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await storage.removeToken();
        await storage.removeUserJson();
      }
      Get.offAllNamed(AppRoutes.login);
    } catch (_) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
