import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:demo_project/app/core/localization/localization_controller.dart';
import 'package:demo_project/app/core/theme/theme_controller.dart';
import 'package:demo_project/app/features/user_list/controller/user_list_controller.dart';
import 'package:demo_project/app/shared/widgets/empty_widget.dart';
import 'package:demo_project/app/shared/widgets/error_widget.dart';
import 'package:demo_project/app/shared/widgets/loading_widget.dart';

import 'widgets/user_tile.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserListController());
    final themeController = Get.find<ThemeController>();
    final localizationController = Get.find<LocalizationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('users'.tr),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                )),
            onPressed: themeController.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: localizationController.toggleLocale,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const LoadingWidget();
        }

        if (controller.hasError.value && controller.users.isEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.refreshUsers,
          );
        }

        if (controller.users.isEmpty) {
          return const EmptyWidget();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshUsers,
          child: ListView.separated(
            itemCount:
                controller.users.length + (controller.hasMore.value ? 1 : 0),
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (index == controller.users.length) {
                controller.loadMoreUsers();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return UserTile(user: controller.users[index]);
            },
          ),
        );
      }),
    );
  }
}
