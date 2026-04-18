import 'dart:io';

import 'package:demo_project/app/core/config/environment.dart';
import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/utils/app_snackbar.dart';
import 'package:demo_project/app/core/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final BaseApiService _api = BaseApiService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  Rx<File?> profileImage = Rx<File?>(null);

  String? remoteImageUrl;
  bool loading = false;
  bool saving = false;
  String? errorMessage;
  int? userId;

  File? get validProfileImage {
    if (profileImage.value == null) return null;
    if (!profileImage.value!.existsSync()) {
      profileImage.value = null;
      return null;
    }
    return profileImage.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  String _formatApiError(ApiException e) {
    final d = e.data;
    if (d is Map) {
      final msg = d['message'];
      if (msg != null) return msg.toString();
      final detail = d['detail'];
      if (detail is List && detail.isNotEmpty) {
        return detail.first.toString();
      }
      if (d['error'] != null) return d['error'].toString();
    }
    return e.message;
  }

  Future<void> fetchProfile({bool showFullLoading = true}) async {
    if (showFullLoading) {
      loading = true;
      errorMessage = null;
      update();
    }
    try {
      final body = await _api.get(
        ApiEndpoints.getProfile,
        timeout: const Duration(seconds: 60),
      );
      if (body is Map && body['data'] is Map) {
        final d = Map<String, dynamic>.from(body['data'] as Map);
        userId = d['id'] is int ? d['id'] as int : int.tryParse('${d['id']}');
        nameController.text = d['full_name']?.toString() ?? '';
        emailController.text = d['email']?.toString() ?? '';
        final raw = d['image'];
        remoteImageUrl = _resolveImageUrl(raw?.toString());
        errorMessage = null;
      }
    } on ApiException catch (e) {
      if (showFullLoading) {
        errorMessage = e.message;
      }
    } catch (e) {
      if (showFullLoading) {
        errorMessage = e.toString();
      }
    } finally {
      if (showFullLoading) {
        loading = false;
      }
      update();
    }
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.error('Please enter your name');
      return;
    }

    saving = true;
    errorMessage = null;
    update();

    try {
      await _api.patchMultipart(
        ApiEndpoints.updateProfile,
        fields: {'full_name': name},
        file: validProfileImage,
        fileFieldName: 'image',
        timeout: const Duration(seconds: 90),
      );
      profileImage.value = null;
      await fetchProfile(showFullLoading: false);
      AppSnackbar.success('Profile updated');
      Get.back();
    } on ApiException catch (e) {
      AppSnackbar.error(_formatApiError(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      saving = false;
      update();
    }
  }

  String? _resolveImageUrl(String? raw) {
    if (raw == null) return null;
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    final origin = Uri.parse(EnvironmentConfig.baseUrl).origin;
    return t.startsWith('/') ? '$origin$t' : '$origin/$t';
  }

  Future<void> pickUserProfileImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );

    if (pickedFile != null && pickedFile.existsSync()) {
      profileImage.value = pickedFile;
    }
  }
}
