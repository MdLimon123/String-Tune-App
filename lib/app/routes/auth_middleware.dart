import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:does_it_doom/app/core/storage/storage_service.dart';
import 'package:does_it_doom/app/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final storage = StorageService();
    if (!storage.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
