import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Reset Password"),
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
                    Get.toNamed(AppRoutes.login);
                  },
                  text: "Set Password",
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
