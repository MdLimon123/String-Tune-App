import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/features/tuning/domain/tuning_models.dart';
import 'package:get/get.dart';

class LibraryController extends GetxController {
  final BaseApiService _api = BaseApiService();

  List<SavedSetup> setups = [];
  bool loading = false;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchLibrary();
  }

  Future<void> fetchLibrary() async {
    loading = true;
    errorMessage = null;
    update();

    try {
      final wb = Get.find<TuningWorkbenchController>();
      final dynamic body = await _api.get(
        ApiEndpoints.library,
        timeout: const Duration(seconds: 90),
      );

      if (body is Map && body['data'] is List) {
        final list = body['data'] as List;
        setups =
            list.map((raw) {
              final m = Map<String, dynamic>.from(raw as Map);
              final tuning = wb.tuningIdFromSelectedTuningApi(
                m['selected_tuning']?.toString() ?? '',
                m['instrument_type']?.toString() ?? 'guitar',
                (m['total_strings'] as int?) ?? 6,
              );
              return SavedSetup.fromLibraryApi(m, tuning);
            }).where((s) => s.gauges.isNotEmpty).toList();
      } else {
        setups = [];
      }
    } on ApiException catch (e) {
      errorMessage = e.message;
      setups = [];
    } catch (e) {
      errorMessage = e.toString();
      setups = [];
    }

    loading = false;
    update();
  }
}
