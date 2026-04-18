import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/utils/app_snackbar.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final isLoading = false.obs;
  final _api = BaseApiService();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> resetPassword({required String password}) async {
    isLoading.value = true;
    try {
      final data = await _api.post(
        ApiEndpoints.resetPassword,
        body: {'new_password': password},
      );
      final msg = _readMessage(data);
      AppSnackbar.success(msg);
      Get.offAllNamed(AppRoutes.login);
    } on ApiException catch (e) {
      AppSnackbar.error(_apiErrorText(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String _readMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ?? 'Success';
    }
    return 'Success';
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
}
