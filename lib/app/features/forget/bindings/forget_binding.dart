import 'package:demo_project/app/features/forget/controller/forget_controller.dart';
import 'package:get/get.dart';

class ForgetBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetController());
  }
}