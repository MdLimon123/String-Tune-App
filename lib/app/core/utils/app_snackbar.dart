import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppSnackbar {
  AppSnackbar._();

  static void show({
    required String title,
    required String message,
    required Color backgroundColor,
    Color colorText = Colors.white,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (message.isEmpty) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      borderRadius: 12,
      duration: duration,
      backgroundColor: backgroundColor,
      colorText: colorText,
    );
  }

  static void error(String message, {String title = 'Error'}) {
    show(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
    );
  }

  static void success(String message, {String title = 'Success'}) {
    show(
      title: title,
      message: message,
      backgroundColor: AppColors.success,
    );
  }
}
