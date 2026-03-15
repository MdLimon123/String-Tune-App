import 'package:demo_project/app/features/library/controller/library_controller.dart';
import 'package:get/get.dart';

class LibraryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LibraryController());
  }
}