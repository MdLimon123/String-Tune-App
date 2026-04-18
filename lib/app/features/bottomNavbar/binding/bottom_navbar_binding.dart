import 'package:demo_project/app/features/bottomNavbar/controller/bottom_navbar_controller.dart';
import 'package:demo_project/app/features/library/controller/library_controller.dart';
import 'package:get/get.dart';

class BottomNavbarBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavbarController());
    if (!Get.isRegistered<LibraryController>()) {
      Get.lazyPut(() => LibraryController());
    }
  }
}