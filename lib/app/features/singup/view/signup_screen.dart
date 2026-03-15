import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/image/app_logo.png', height: 100),
                ),

                Text(
                  "Name",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                CustomTextField(
                  filColor: Color(0xFF0F172A),
                  filled: true,
                  hintText: "Enter your name",
                  prefixIcon: SvgPicture.asset('assets/icon/user.svg'),
                ),
                SizedBox(height: 20),

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
                  isPassword: true,
                  filColor: Color(0xFF0F172A),
                  filled: true,
                  hintText: "Enter your password",
                  prefixIcon: SvgPicture.asset('assets/icon/lock.svg'),
                ),
                SizedBox(height: 12),
                CustomTextField(
                  isPassword: true,
                  filColor: Color(0xFF0F172A),
                  filled: true,
                  hintText: "Re-enter your password",
                  prefixIcon: SvgPicture.asset('assets/icon/lock.svg'),
                ),

                SizedBox(height: 32),
                CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.emailVerify);
                  },
                  text: "Sign Up",
                ),
                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.login);
                      },
                      child: Text(
                        " Login",
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
    );
  }
}
