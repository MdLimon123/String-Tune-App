import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/features/resetPassword/controller/reset_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final _resetPasswordController = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Reset Password"),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _resetPasswordController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/image/app_logo.png',
                      height: 100,
                    ),
                  ),

                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomTextField(
                    controller: _resetPasswordController.passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    isPassword: true,
                    filColor: Color(0xFF0F172A),
                    filled: true,
                    hintText: "Enter your password",
                    prefixIcon: SvgPicture.asset('assets/icon/lock.svg'),
                  ),
                  SizedBox(height: 12),
                  CustomTextField(
                    controller:
                        _resetPasswordController.confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm password is required';
                      }
                      if (value !=
                          _resetPasswordController.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    isPassword: true,
                    filColor: Color(0xFF0F172A),
                    filled: true,
                    hintText: "Re-enter your password",
                    prefixIcon: SvgPicture.asset('assets/icon/lock.svg'),
                  ),

                  SizedBox(height: 32),
                  Obx(
                    () => CustomButton(
                      loading: _resetPasswordController.isLoading.value,
                      onTap: () {
                        if (_resetPasswordController.formKey.currentState!
                            .validate()) {
                          _resetPasswordController.resetPassword(
                            password: _resetPasswordController
                                .passwordController
                                .text,
                          );
                        }
                      },
                      text: "Set Password",
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
