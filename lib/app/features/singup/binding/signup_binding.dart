import 'package:does_it_doom/app/features/singup/controller/signup_controller.dart';
import 'package:get/get.dart';

class SignupBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController());
  }
}