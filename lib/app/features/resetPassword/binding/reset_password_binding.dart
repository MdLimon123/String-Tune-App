import 'package:demo_project/app/features/resetPassword/controller/reset_controller.dart';
import 'package:get/get.dart';

class ResetPasswordBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordController());
  }
}