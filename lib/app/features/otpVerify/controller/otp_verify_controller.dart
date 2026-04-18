import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/core/utils/app_snackbar.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyController extends GetxController{

  final isLoading = false.obs;
  final _api = BaseApiService();
  final _storage = StorageService();


  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  String get otpCode => otpControllers.map((c) => c.text).join();


  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }


  void verifyOtp() {
    if (otpCode.length == 6) {
      
      // API call here
    } else {
      Get.snackbar("Error", "Please enter complete OTP");
    }
  }



  Future<void> otpVerify({required String email, required String otp}) async {
    isLoading.value = true;
    try {
      final data = await _api.post(
        ApiEndpoints.emailVerify,
        body: {'email': email, 'otp': otp},
      );

      final map = Map<String, dynamic>.from(data as Map);
      await _storage.saveToken((map['access'] ?? '').toString());

      AppSnackbar.success((map['message'] ?? 'OTP verified').toString());
      Get.offAllNamed(AppRoutes.resetPassword);
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

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }


}