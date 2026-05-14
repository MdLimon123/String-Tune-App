import 'package:does_it_doom/app/features/emailVerify/controller/email_verify_controller.dart';
import 'package:get/get.dart';

class EmailVerifyBinding extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => EmailVerifyController());
  }
}