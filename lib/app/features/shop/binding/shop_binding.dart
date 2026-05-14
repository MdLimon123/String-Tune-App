import 'package:does_it_doom/app/features/shop/controller/shop_controller.dart';
import 'package:get/get.dart';
class ShopBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ShopController());
  }
}