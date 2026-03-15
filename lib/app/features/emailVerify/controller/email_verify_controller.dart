import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerifyController extends GetxController{



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