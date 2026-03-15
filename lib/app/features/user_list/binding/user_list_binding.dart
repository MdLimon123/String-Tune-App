import 'package:get/get.dart';

import 'package:demo_project/app/features/user_list/controller/user_list_controller.dart';

class UserListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserListController>(() => UserListController());
  }
}
