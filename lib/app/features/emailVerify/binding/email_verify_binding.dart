import 'package:demo_project/app/features/emailVerify/controller/email_verify_controller.dart';
import 'package:get/get.dart';

class EmailVerifyBinding extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => EmailVerifyController());
  }
}