import 'package:does_it_doom/app/features/otpVerify/controller/otp_verify_controller.dart';
import 'package:get/get.dart';

class OtpVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpVerifyController());
  }
}
