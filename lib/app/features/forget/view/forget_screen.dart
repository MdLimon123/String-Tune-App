import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/features/forget/controller/forget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ForgetScreen extends StatefulWidget {
  ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _forgetController = Get.find<ForgetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CustomAppbar(title: "Forgot Password"),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _forgetController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Forgot Password ?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Please enter your email address to reset your password.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),

                  CustomTextField(
                    controller: _forgetController.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                    filColor: Color(0xFF0F172A),
                    filled: true,
                    hintText: "Enter your email",
                    prefixIcon: SvgPicture.asset('assets/icon/email.svg'),
                  ),

                  SizedBox(height: 24),
                  Obx(
                    () => CustomButton(
                      loading: _forgetController.isLoading.value,
                      onTap: () {
                        if (_forgetController.formKey.currentState!
                            .validate()) {
                          _forgetController.forgetPassword(
                            email: _forgetController.emailController.text,
                          );
                        }
                      },
                      text: "Send OTP",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
