import 'package:demo_project/app/features/buildSetup/controller/build_setup_controller.dart';
import 'package:get/get.dart';

class BuildSetupBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BuildSetupController());
  }
}