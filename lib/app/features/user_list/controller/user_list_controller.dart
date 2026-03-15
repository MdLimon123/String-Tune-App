import 'package:demo_project/app/core/base/base_controller.dart';
import 'package:demo_project/app/core/constants/app_constants.dart';
import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/features/user_list/model/user_model.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:get/get.dart';

class UserListController extends BaseController {
  final _api = BaseApiService();

  final users = <UserModel>[].obs;
  int _currentPage = 1;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    _currentPage = 1;
    hasMore.value = true;
    users.clear();

    final result = await apiCall<List<UserModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.users,
          queryParams: {
            'page': _currentPage,
            'limit': AppConstants.paginationLimit,
          },
        );
        final list = data['data'] as List;
        return list
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    if (result != null) {
      users.addAll(result);
      hasMore.value = result.length >= AppConstants.paginationLimit;
      _currentPage++;
    }
  }

  Future<void> loadMoreUsers() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final result = await apiCall<List<UserModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.users,
          queryParams: {
            'page': _currentPage,
            'limit': AppConstants.paginationLimit,
          },
        );
        final list = data['data'] as List;
        return list
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      showLoading: false,
    );

    if (result != null) {
      users.addAll(result);
      hasMore.value = result.length >= AppConstants.paginationLimit;
      _currentPage++;
    }

    isLoadingMore.value = false;
  }

  Future<void> refreshUsers() => loadUsers();

  void logout() {
    StorageService().removeToken();
    Get.offAllNamed(AppRoutes.login);
  }
}
