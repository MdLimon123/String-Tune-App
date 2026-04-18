import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/app_snackbar.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/features/emailVerify/controller/email_verify_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerifyScreen extends StatelessWidget {
  final String email;
  EmailVerifyScreen({super.key, required this.email});

  final _emailVerifyController = Get.find<EmailVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Email Verification"),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/image/app_logo.png', height: 100),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 48,
                      child: TextField(
                        controller:
                            _emailVerifyController.otpControllers[index],
                        focusNode: _emailVerifyController.focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Color(0xFF0F172A),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              color: Color(0xFF94A3B8),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                              color: Color(0xFF94A3B8),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) =>
                            _emailVerifyController.onOtpChanged(value, index),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 32),
                Obx(
                  () => CustomButton(
                    loading: _emailVerifyController.isLoading.value,
                    onTap: () {
                      if (_emailVerifyController.otpCode.length == 6) {
                        _emailVerifyController.emailVerify(
                          email: email,
                          otp: _emailVerifyController.otpCode,
                        );
                      } else {
                        AppSnackbar.error('Please enter complete OTP');
                      }
                    },
                    text: "Verify",
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t get the code?',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      " Resend",
                      style: TextStyle(
                        color: Color(0xFFA855F7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
