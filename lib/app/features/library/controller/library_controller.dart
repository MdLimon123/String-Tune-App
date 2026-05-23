import 'package:does_it_doom/app/core/network/api_endpoints.dart';
import 'package:does_it_doom/app/core/network/api_exception.dart';
import 'package:does_it_doom/app/core/network/base_api_service.dart';
import 'package:does_it_doom/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:does_it_doom/app/features/tuning/domain/tuning_models.dart';
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

  Future<bool> renameSetup(int id, String newName) async {
    if (newName.trim().isEmpty) return false;
    try {
      await _api.patch(
        ApiEndpoints.calculateStringTensionEdit(id),
        body: {
          'setup_name': newName.trim(),
        },
        timeout: const Duration(seconds: 90),
      );
      // Update local item in the setups list immediately
      setups = setups.map((s) {
        if (s.id == id) {
          return SavedSetup(
            id: s.id,
            name: newName.trim(),
            instrument: s.instrument,
            stringCount: s.stringCount,
            gauges: s.gauges,
            woundFlags: s.woundFlags,
            scaleLength: s.scaleLength,
            tuning: s.tuning,
            savedAt: s.savedAt,
          );
        }
        return s;
      }).toList();
      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSetup(int id) async {
    try {
      await _api.delete(
        ApiEndpoints.calculateStringTensionEdit(id),
        timeout: const Duration(seconds: 90),
      );
      setups.removeWhere((s) => s.id == id);
      update();
      return true;
    } catch (e) {
      return false;
    }
  }
}
