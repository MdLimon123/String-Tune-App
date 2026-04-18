import 'package:demo_project/app/core/global/loading_controller.dart';
import 'package:demo_project/app/core/network/api_endpoints.dart';
import 'package:demo_project/app/core/network/api_exception.dart';
import 'package:demo_project/app/core/network/base_api_service.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/features/tuning/domain/tuning_data.dart';
import 'package:demo_project/app/features/tuning/domain/tuning_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CalculateSaveResult { saved, duplicate, invalid, networkError }

/// Calculator UI state and values (string tension screen).
class CalculateController extends GetxController {
  final BaseApiService _api = BaseApiService();
  late final TuningWorkbenchController wb;

  final TextEditingController setupName = TextEditingController();

  /// Filled when [saveSetupToServerAndLibrary] returns [CalculateSaveResult.networkError].
  String lastSaveErrorMessage = '';

  String instrument = 'guitar';
  int stringCount = 6;
  bool multiScale = false;
  double scaleLength = 25.5;
  List<double> perStringScales = List.filled(6, 25.5);
  String tuning = 'C';
  /// String material for tension math on this screen only.
  String stringType = 'nickel';
  List<String> gauges = [...defaultGuitarGauges[6]!];
  List<bool> wounds = [...defaultWoundGuitar[6]!];
  List<double> tensions = [];

  bool showTuningDropdown = false;
  bool showStringTypeDropdown = false;

  double get stringTypeMult =>
      stringTypes.firstWhereOrNull((e) => e.id == stringType)?.mult ?? 1.0;

  List<String> get stringTypeLabels => stringTypes.map((e) => e.label).toList();

  double get totalTension =>
      tensions.fold<double>(0.0, (a, b) => a + b);

  @override
  void onInit() {
    super.onInit();
    wb = Get.find<TuningWorkbenchController>();
    _recalcTensions();
  }

  @override
  void onClose() {
    setupName.dispose();
    super.onClose();
  }

  String _formatApiError(ApiException e) {
    final d = e.data;
    if (d is Map) {
      final msg = d['message'];
      if (msg != null) return msg.toString();
      final detail = d['detail'];
      if (detail is List) {
        final parts = detail
            .map((x) {
              if (x is Map) {
                final loc = x['loc'];
                final m = x['msg'] ?? x['message'];
                return '${loc != null ? '$loc: ' : ''}${m ?? x}';
              }
              return x.toString();
            })
            .where((s) => s.isNotEmpty)
            .join('\n');
        if (parts.isNotEmpty) return parts;
      } else if (detail != null) {
        return detail.toString();
      }
      if (d['error'] != null) return d['error'].toString();
      if (d['errors'] != null) return d['errors'].toString();
      if (d.isNotEmpty) return d.toString();
    }
    return e.message;
  }

  String _stringTypeForApi() => stringType.toLowerCase().trim();

  /// API: max 2 decimal places (Django/DRF style validation).
  double _apiDecimal2(double x) => double.parse(x.toStringAsFixed(2));

  String resolveStringTypeLabel(String id) {
    return stringTypes.firstWhereOrNull((e) => e.id == id)?.label ??
        'Nickel Wound';
  }

  String resolveStringTypeId(String label) {
    return stringTypes.firstWhereOrNull((e) => e.label == label)?.id ??
        'nickel';
  }

  void openStringTypeDropdown() {
    showStringTypeDropdown = true;
    showTuningDropdown = false;
    update();
  }

  void openTuningDropdown() {
    showTuningDropdown = true;
    showStringTypeDropdown = false;
    update();
  }

  void hideDropdownOverlays() {
    showTuningDropdown = false;
    showStringTypeDropdown = false;
    update();
  }

  void closeTuningDropdown() {
    showTuningDropdown = false;
    update();
  }

  void closeStringTypeDropdown() {
    showStringTypeDropdown = false;
    update();
  }

  void changeInstrument(bool isGuitar) {
    instrument = isGuitar ? 'guitar' : 'bass';
    stringCount = isGuitar ? 6 : 4;
    scaleLength = isGuitar ? 25.5 : 34.0;
    perStringScales = List.filled(stringCount, scaleLength);

    final g = instrument == 'bass'
        ? defaultBassGauges[stringCount]!
        : defaultGuitarGauges[stringCount]!;
    final w = instrument == 'bass'
        ? defaultWoundBass[stringCount]!
        : defaultWoundGuitar[stringCount]!;

    gauges = [...g];
    wounds = [...w];
    _recalcTensions();
    update();
  }

  void changeStringCount(int value) {
    if (instrument == 'guitar') {
      stringCount = value.clamp(6, 8);
    } else {
      stringCount = value.clamp(4, 6);
    }

    perStringScales = List.filled(stringCount, scaleLength);
    final g = instrument == 'bass'
        ? defaultBassGauges[stringCount]!
        : defaultGuitarGauges[stringCount]!;
    final w = instrument == 'bass'
        ? defaultWoundBass[stringCount]!
        : defaultWoundGuitar[stringCount]!;

    gauges = [...g];
    wounds = [...w];
    _recalcTensions();
    update();
  }

  void setScaleLength(double scale) {
    scaleLength = scale;
    _recalcTensions();
    update();
  }

  void setPerStringScale(int index, double scale) {
    if (index >= perStringScales.length) return;
    perStringScales[index] = scale;
    _recalcTensions();
    update();
  }

  void setMultiScale(bool value) {
    multiScale = value;
    _recalcTensions();
    update();
  }

  void setTuningByLabel(String label) {
    tuning = wb.resolveTuningId(label);
    _recalcTensions();
    update();
  }

  void setStringTypeByLabel(String label) {
    stringType = resolveStringTypeId(label);
    _recalcTensions();
    update();
  }

  void bumpGauge(int index, int dir) {
    if (index >= gauges.length) return;
    gauges[index] = wb.bumpGaugeStep(gauges[index], wounds[index], dir);
    _recalcTensions();
    update();
  }

  void toggleWound(int index, bool wound) {
    if (index >= wounds.length) return;
    wounds[index] = wound;
    gauges[index] = wb.snapGaugeStep(gauges[index], wound);
    _recalcTensions();
    update();
  }

  void _recalcTensions() {
    final freqs = wb.getStringFreqs(instrument, stringCount, tuning);
    final scales = multiScale
        ? perStringScales.take(stringCount).toList()
        : List.filled(stringCount, scaleLength);

    tensions = List.generate(stringCount, (i) {
      return wb.computeTension(
        gauge: gauges[i],
        wound: wounds[i],
        scaleInches: scales[i],
        freqHz: freqs[i],
        stringTypeMult: stringTypeMult,
      );
    });
  }

  void applySavedSetup(SavedSetup setup) {
    instrument = setup.instrument;
    stringCount = setup.stringCount;
    gauges = [...setup.gauges];
    wounds = [...setup.woundFlags];
    tuning = setup.tuning;

    final split = setup.scaleLength.split(',');
    if (split.length > 1) {
      multiScale = true;
      perStringScales = split
          .map((e) => double.tryParse(e.trim()) ?? 25.5)
          .toList();
      scaleLength = perStringScales.isEmpty ? 25.5 : perStringScales.first;
    } else {
      multiScale = false;
      scaleLength = double.tryParse(setup.scaleLength) ?? 25.5;
      perStringScales = List.filled(stringCount, scaleLength);
    }

    _recalcTensions();
    update();
  }

  void applyFromBuildResult(ComputedSetup result) {
    instrument = result.instrument;
    stringCount = result.stringCount;
    gauges = [...result.gauges];
    wounds = [...result.wounds];
    tuning = result.tuning;

    final allSameScale = result.scales.every(
      (s) => (s - result.scales.first).abs() < 0.001,
    );
    multiScale = !allSameScale;
    scaleLength = result.scales.first;
    perStringScales = [...result.scales];

    _recalcTensions();
    update();
  }

  void applyFromMatchResult({
    required String srcInstrument,
    required int count,
    required List<String> gaugeList,
    required List<bool> woundList,
    required String tuningId,
    required bool multi,
    required double singleScale,
    required List<double> scaleList,
  }) {
    instrument = srcInstrument;
    stringCount = count;
    gauges = gaugeList.take(count).toList();
    wounds = woundList.take(count).toList();
    tuning = tuningId;
    multiScale = multi;
    scaleLength = singleScale;
    perStringScales = multi
        ? scaleList.take(count).toList()
        : List.filled(count, singleScale);

    _recalcTensions();
    update();
  }

  void applyFromArtistParsed({
    required String inst,
    required int count,
    required List<String> gaugeVals,
    required List<bool> woundVals,
    required double scale,
    required String tuningId,
  }) {
    instrument = inst;
    stringCount = count;
    gauges = [...gaugeVals];
    wounds = [...woundVals];
    scaleLength = scale;
    perStringScales = List.filled(stringCount, scaleLength);
    tuning = tuningId;
    multiScale = false;

    _recalcTensions();
    update();
  }

  void applyFromArtistEdited({
    required String inst,
    required int count,
    required List<String> gaugeVals,
    required List<bool> woundVals,
    required String tuningId,
    required List<double> scales,
  }) {
    instrument = inst;
    stringCount = count;
    gauges = [...gaugeVals];
    wounds = [...woundVals];
    tuning = tuningId;
    final allSame = scales.every((s) => (s - scales.first).abs() < 0.001);
    multiScale = !allSame;
    scaleLength = scales.first;
    perStringScales = [...scales];

    _recalcTensions();
    update();
  }

  Future<CalculateSaveResult> saveSetupToServerAndLibrary([
    String? customName,
  ]) async {
    lastSaveErrorMessage = '';
    final trimmedField = setupName.text.trim();
    final resolvedName =
        (customName != null && customName.trim().isNotEmpty)
            ? customName.trim()
            : (trimmedField.isEmpty ? null : trimmedField);

    final scale = multiScale
        ? perStringScales
              .take(stringCount)
              .map((s) => s.toStringAsFixed(2))
              .join(',')
        : scaleLength.toStringAsFixed(2);

    final cleanGauges =
        gauges.take(stringCount).map((g) => g.trim()).toList();
    final cleanWounds = wounds.take(stringCount).toList();

    if (!wb.validateSetupPayload(
      stringCount: stringCount,
      gauges: cleanGauges,
      wounds: cleanWounds,
      scale: scale,
    )) {
      return CalculateSaveResult.invalid;
    }

    final normalizedScale = wb.normalizeScaleString(scale);
    if (wb.isSavedSetupDuplicate(
      instrument: instrument,
      stringCount: stringCount,
      cleanGauges: cleanGauges,
      cleanWounds: cleanWounds,
      normalizedScale: normalizedScale,
      tuning: tuning,
    )) {
      return CalculateSaveResult.duplicate;
    }

    try {
      final body = _buildLibraryPayload(resolvedName);
      final loading = Get.find<LoadingController>();
      loading.show();
      try {
        // Dev tunnels / cold starts often exceed the default 30s client timeout.
        await _api.post(
          ApiEndpoints.calculateStringTension,
          body: body,
          timeout: const Duration(seconds: 90),
        );
      } finally {
        loading.hide();
      }
    } on ApiException catch (e) {
      lastSaveErrorMessage = _formatApiError(e);
      return CalculateSaveResult.networkError;
    } catch (e) {
      lastSaveErrorMessage = e.toString();
      return CalculateSaveResult.networkError;
    }

    final local = await wb.saveSetupToLibrary(
      name: resolvedName,
      instrument: instrument,
      stringCount: stringCount,
      gauges: gauges,
      wounds: wounds,
      scale: scale,
      tuning: tuning,
    );

    if (local == SaveSetupResult.saved) {
      setupName.clear();
      return CalculateSaveResult.saved;
    }
    if (local == SaveSetupResult.duplicate) {
      return CalculateSaveResult.duplicate;
    }
    return CalculateSaveResult.invalid;
  }

  List<double> _perStringScalesForApi() {
    if (multiScale) {
      return List.generate(
        stringCount,
        (i) =>
            i < perStringScales.length ? perStringScales[i] : scaleLength,
      );
    }
    return List.filled(stringCount, scaleLength);
  }

  double _gaugeStringToInches(String raw) {
    final s = raw.trim().replaceAll(RegExp(r'[wp]$', caseSensitive: false), '');
    final v = double.tryParse(s) ?? 0.0;
    return _apiDecimal2(v);
  }

  /// e.g. E standard → `EADGBE` (low string to high, pitch tokens).
  String _selectedTuningForApi() {
    final names = wb.getStringNames(instrument, stringCount, tuning);
    return names.reversed.map(_pitchToken).join();
  }

  String _pitchToken(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return t;
    return t[0].toUpperCase() + (t.length > 1 ? t.substring(1) : '');
  }

  Map<String, dynamic> _buildLibraryPayload(String? customName) {
    final n = stringCount;
    final names = wb.getStringNames(instrument, n, tuning);
    final scales = _perStringScalesForApi();
    final payloadSetupName = (customName == null || customName.trim().isEmpty)
        ? 'Setup ${wb.savedSetups.length + 1}'
        : customName.trim();

    final strings = List.generate(n, (i) {
      final g = i < gauges.length ? gauges[i] : '';
      final wound = i < wounds.length ? wounds[i] : false;
      final tension = i < tensions.length ? tensions[i] : 0.0;
      return {
        'string_name': names[i],
        'type': wound ? 'w' : 'p',
        'scale': _apiDecimal2(scales[i]),
        'gauge': _gaugeStringToInches(g),
        'tension': _apiDecimal2(tension),
      };
    });

    return {
      'setup_name': payloadSetupName,
      'instrument_type': instrument,
      'total_strings': n,
      'scale_sength': _apiDecimal2(scaleLength),
      'is_multi_scale': multiScale,
      'string_type': _stringTypeForApi(),
      'selected_tuning': _selectedTuningForApi(),
      'total_tension': _apiDecimal2(totalTension),
      'is_public': true,
      'is_varified': false,
      'strings': strings,
    };
  }
}
