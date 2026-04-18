import 'dart:convert';

import 'package:demo_project/app/core/base/base_controller.dart';
import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/core/utils/app_snackbar.dart';
import 'package:demo_project/app/core/validation/base_validator.dart';
import 'package:demo_project/app/features/login/model/login_response.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;

  final _api = BaseApiService();
  final _storage = StorageService();

  String? validateEmail(String? value) => BaseValidator.validateEmail(value);

  String? validatePassword(String? value) => BaseValidator.validatePassword(value);

  void togglePasswordVisibility() => obscurePassword.toggle();


  Future<void> login({
    required String email,
    required String password,
  }) async {
    final body = {'email': email, 'password': password};

    isLoading.value = true;
    try {
      final data = await _api.post(
        ApiEndpoints.login,
        body: body,
      );
      final result = LoginResponse.fromJson(
        Map<String, dynamic>.from(data as Map),
      );

      final token = result.effectiveToken;
      if (token != null && token.isNotEmpty) {
        await _storage.saveToken(token);
      }
      final u = result.user;
      if (u != null) {
        await _storage.saveUserJson(jsonEncode(u.toJson()));
      }

      final msg = result.message ?? 'Login successful';
      AppSnackbar.success(msg);
      Get.offAllNamed(AppRoutes.bottomNavbar);
    } on ApiException catch (e) {
      AppSnackbar.error(_apiErrorText(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String _apiErrorText(ApiException e) {
    final d = e.data;
    if (d is Map && d['message'] != null) return d['message'].toString();
    if (d is Map && d['detail'] != null) {
      final detail = d['detail'];
      if (detail is List && detail.isNotEmpty) return detail.first.toString();
      return detail.toString();
    }
    return e.message;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
