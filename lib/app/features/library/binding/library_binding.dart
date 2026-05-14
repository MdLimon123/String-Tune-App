import 'package:does_it_doom/app/features/library/controller/library_controller.dart';
import 'package:get/get.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LibraryController>()) {
      Get.lazyPut(() => LibraryController());
    }
  }
}