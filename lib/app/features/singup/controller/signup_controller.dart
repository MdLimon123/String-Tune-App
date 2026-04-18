import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/utils/app_snackbar.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final _api = BaseApiService();

  final isLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final data = await _api.post(
        ApiEndpoints.register,
        body: {
          'full_name': name,
          'email': email,
          'password': password,
        },
      );

      final msg = _readMessage(data) ?? 'Success';
      AppSnackbar.success(msg);
      Get.toNamed(AppRoutes.emailVerify, arguments: {'email': email});
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

  String? _readMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }
}
