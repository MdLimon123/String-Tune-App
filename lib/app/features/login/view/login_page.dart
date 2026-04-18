import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/features/login/controller/login_controller.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _loginController.formKey,
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
                    "Email",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),

                  CustomTextField(
                    controller: _loginController.emailController,
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
                  SizedBox(height: 20),

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
                    controller: _loginController.passwordController,
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

                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.forget);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFFA855F7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),
                  Obx(
                    () => CustomButton(
                      loading: _loginController.isLoading.value,
                      onTap: () {
                        if (_loginController.formKey.currentState!.validate()) {
                          _loginController.login(
                            email: _loginController.emailController.text,
                            password: _loginController.passwordController.text,
                          );
                        }
                      },
                      text: "Login",
                    ),
                  ),

                  SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.signup);
                        },
                        child: Text(
                          " Sign Up",
                          style: TextStyle(
                            color: Color(0xFFA855F7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
