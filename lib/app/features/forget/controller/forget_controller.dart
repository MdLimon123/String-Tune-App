
import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/utils/app_snackbar.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetController extends GetxController{

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final _api = BaseApiService();


  Future<void> forgetPassword({required String email}) async {
    isLoading.value = true;
    try {
      final data = await _api.post(
        ApiEndpoints.forgetPassword,
        body: {'email': email},
      );
      final msg = _readMessage(data) ;
      AppSnackbar.success(msg);
      Get.toNamed(AppRoutes.otpVerify, arguments: {'email': email});
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

  String _readMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ?? 'Success';
    }
    return 'Success';
  }



}