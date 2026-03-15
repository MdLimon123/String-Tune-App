
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:demo_project/app/core/base/base_controller.dart';
import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/core/validation/base_validator.dart';
import 'package:demo_project/app/features/login/model/login_response.dart';
import 'package:demo_project/app/routes/app_routes.dart';

class LoginController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "user@test.com");
  final passwordController = TextEditingController(text: "StrongPass123!");
  final obscurePassword = true.obs;

  final _api = BaseApiService();
  final _storage = StorageService();

  String? validateEmail(String? value) => BaseValidator.validateEmail(value);

  String? validatePassword(String? value) => BaseValidator.validatePassword(value);

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

   var body = {
      "email": "user@test.com",
      "password": "StrongPass123!"
  };

    final result = await apiCall<LoginResponse>(
      () async {
        final data = await _api.post(
          ApiEndpoints.login,
          body: body,
        );
        return LoginResponse.fromJson(data as Map<String, dynamic>);
      },
      showOverlay: true,
    );

    if (result != null) {
      await _storage.saveToken(result.data?.access ?? '');
      Get.offAllNamed(AppRoutes.products);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
