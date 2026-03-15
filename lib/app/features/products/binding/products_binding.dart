import 'package:get/get.dart';

import 'package:demo_project/app/features/products/controller/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsController>(() => ProductsController());
  }
}
