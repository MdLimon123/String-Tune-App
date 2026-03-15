import 'package:demo_project/app/features/bottomNavbar/controller/bottom_navbar_controller.dart';
import 'package:get/get.dart';

class BottomNavbarBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavbarController());
  }
}