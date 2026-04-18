import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/features/tuning/domain/tuning_data.dart';
import 'package:demo_project/app/features/tuning/domain/tuning_models.dart';
import 'package:get/get.dart';

/// Legend library list + filters. Data from GET [ApiEndpoints.getArtistTunings].
class ArtistController extends GetxController {
  final BaseApiService _api = BaseApiService();

  static const List<String> genreFilters = [
    'All',
    'Doom',
    'Sludge',
    'Drone',
    'Rock',
    'Blues',
    'Metal',
  ];

  List<ArtistTuningEntry> _legendEntries = [];
  String artistFilter = 'All';
  String artistSearch = '';

  bool loading = false;
  String? errorMessage;

  bool get hasLegendData => _legendEntries.isNotEmpty;

  String resolveTuningLabel(String tuningId) {
    return tuningList.firstWhereOrNull((e) => e.id == tuningId)?.label ??
        tuningId;
  }

  List<ArtistTuningEntry> get filteredArtists {
    final query = artistSearch.trim().toLowerCase();
    return _legendEntries.where((artist) {
      final byGenre = artistFilter == 'All' || artist.genre == artistFilter;
      final bySearch =
          query.isEmpty ||
          artist.name.toLowerCase().contains(query) ||
          artist.band.toLowerCase().contains(query) ||
          artist.era.toLowerCase().contains(query) ||
          resolveTuningLabel(artist.tuning).toLowerCase().contains(query);
      return byGenre && bySearch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLegendTunings();
  }

  Future<void> fetchLegendTunings() async {
    loading = true;
    errorMessage = null;
    update();

    try {
      final wb = Get.find<TuningWorkbenchController>();
      final body = await _api.get(
        ApiEndpoints.getArtistTunings,
        timeout: const Duration(seconds: 90),
      );

      if (body is Map && body['data'] is List) {
        final list = body['data'] as List;
        _legendEntries =
            list.map((raw) {
              final m = Map<String, dynamic>.from(raw as Map);
              final tuning = wb.tuningIdFromSelectedTuningApi(
                m['selected_tuning']?.toString() ?? '',
                m['instrument_type']?.toString() ?? 'guitar',
                (m['total_strings'] as int?) ?? 6,
              );
              return ArtistTuningEntry.fromLegendApi(m, tuning);
            }).where((e) => e.gauges.isNotEmpty).toList();
      } else {
        _legendEntries = [];
      }
    } on ApiException catch (e) {
      errorMessage = e.message;
      _legendEntries = [];
    } catch (e) {
      errorMessage = e.toString();
      _legendEntries = [];
    }

    loading = false;
    update();
  }

  void setArtistFilter(String value) {
    artistFilter = value;
    update();
  }

  void setArtistSearch(String value) {
    artistSearch = value;
    update();
  }
}
