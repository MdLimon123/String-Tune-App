import 'package:get/get.dart';

import 'package:demo_project/app/core/base/base_controller.dart';
import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/features/products/model/product_model.dart';
import 'package:demo_project/app/routes/app_routes.dart';

class ProductsController extends BaseController {
  final _api = BaseApiService();

  final products = <ProductModel>[].obs;
  int _currentPage = 1;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    _currentPage = 1;
    hasMore.value = true;
    products.clear();

    final result = await apiCall<List<ProductModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.products,
          queryParams: {'page': _currentPage},
        );
        final responseData = data['data'] as Map<String, dynamic>;
        hasMore.value = responseData['next'] != null;
        final list = responseData['results'] as List;
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    if (result != null) {
      products.addAll(result);
      _currentPage++;
    }
  }

  Future<void> loadMoreProducts() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;

    final result = await apiCall<List<ProductModel>>(
      () async {
        final data = await _api.get(
          ApiEndpoints.products,
          queryParams: {'page': _currentPage},
        );
        final responseData = data['data'] as Map<String, dynamic>;
        hasMore.value = responseData['next'] != null;
        final list = responseData['results'] as List;
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      showLoading: false,
    );

    if (result != null) {
      products.addAll(result);
      _currentPage++;
    }

    isLoadingMore.value = false;
  }

  Future<void> refreshProducts() => loadProducts();

  void logout() {
    StorageService().removeToken();
    Get.offAllNamed(AppRoutes.login);
  }
}
