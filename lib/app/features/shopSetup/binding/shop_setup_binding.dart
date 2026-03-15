import 'package:demo_project/app/features/shopSetup/controller/show_setup_controller.dart';
import 'package:get/get.dart';

class ShopSetupBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ShowSetupController());
  }
}