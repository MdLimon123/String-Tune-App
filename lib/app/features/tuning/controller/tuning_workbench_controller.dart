import 'dart:convert';
import 'dart:math' as math;

import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:get/get.dart';

import '../domain/tuning_data.dart';
import '../domain/tuning_models.dart';

enum SaveSetupResult { saved, duplicate, invalid }

class TuningWorkbenchController extends GetxController {
  // Calculator state
  String calcInstrument = 'guitar';
  int calcStringCount = 6;
  bool calcMultiScale = false;
  double calcScaleLength = 25.5;
  List<double> calcStringScales = List.filled(6, 25.5);
  String calcTuning = 'C';
  String stringType = 'nickel';
  List<String> calcGauges = [...defaultGuitarGauges[6]!];
  List<bool> calcWounds = [...defaultWoundGuitar[6]!];
  List<double> calcTensions = [];

  // Match state
  String srcInstrument = 'guitar';
  int srcStringCount = 6;
  bool srcMultiScale = false;
  double srcScale = 25.5;
  List<double> srcScales = List.filled(6, 25.5);
  String srcTuning = 'E';
  List<String> srcGauges = [...defaultGuitarGauges[6]!];
  List<bool> srcWounds = [...defaultWoundGuitar[6]!];
  List<double> srcTensions = [];

  bool tgtMultiScale = false;
  double tgtScale = 25.5;
  List<double> tgtScales = List.filled(6, 25.5);
  String tgtTuning = 'C';
  List<String> tgtGauges = [];
  List<bool> tgtWounds = [...defaultWoundGuitar[6]!];
  List<double> tgtTensions = [];
  bool matchGenerated = false;

  // Build state
  String buildInstrument = 'guitar';
  int buildStringCount = 6;
  bool buildMultiScale = false;
  double buildSingleScale = 25.5;
  List<double> buildScales = List.filled(6, 25.5);
  String buildTuning = 'E';
  String? buildFeelId;
  ComputedSetup? buildResult;

  // Artist/library
  String artistFilter = 'All';
  String artistSearch = '';
  ArtistTuningEntry? selectedArtist;
  List<String>? artistEditedGauges;
  List<bool>? artistEditedWounds;
  List<double>? artistEditedTensions;
  List<double>? artistEditedScales;
  String? artistEditedTuning;
  String? artistEditedInstrument;

  // Saved setups
  List<SavedSetup> savedSetups = [];

  // Shop
  List<String> shopGauges = [];
  List<bool> shopWounds = [];
  String shopPackName = '';

  double get stringTypeMult {
    return stringTypes
            .firstWhereOrNull((element) => element.id == stringType)
            ?.mult ??
        1.0;
  }

  List<String> get tuningLabels => tuningList.map((e) => e.label).toList();

  List<String> get stringTypeLabels => stringTypes.map((e) => e.label).toList();

  List<String> get genres {
    final set = <String>{'All'};
    for (final artist in artistTunings) {
      set.add(artist.genre);
    }
    return set.toList();
  }

  List<ArtistTuningEntry> get filteredArtists {
    final query = artistSearch.trim().toLowerCase();
    return artistTunings.where((artist) {
      final byGenre = artistFilter == 'All' || artist.genre == artistFilter;
      final bySearch =
          query.isEmpty ||
          artist.name.toLowerCase().contains(query) ||
          artist.band.toLowerCase().contains(query) ||
          resolveTuningLabel(artist.tuning).toLowerCase().contains(query);
      return byGenre && bySearch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _recalcCalc();
    _recalcSrc();
    _loadSavedSetups();
  }

  Future<void> _loadSavedSetups() async {
    final raw = StorageService().getSavedSetupsJson();
    if (raw == null || raw.isEmpty) {
      update();
      return;
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      savedSetups = decoded
          .map((e) => SavedSetup.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      savedSetups = [];
    }
    update();
  }

  Future<void> _persistSavedSetups() async {
    final jsonStr = jsonEncode(savedSetups.map((e) => e.toJson()).toList());
    await StorageService().saveSavedSetupsJson(jsonStr);
  }

  String resolveTuningLabel(String tuningId) {
    return tuningList.firstWhereOrNull((e) => e.id == tuningId)?.label ??
        tuningId;
  }

  String resolveTuningId(String tuningLabel) {
    return tuningList.firstWhereOrNull((e) => e.label == tuningLabel)?.id ??
        'E';
  }

  String resolveStringTypeId(String label) {
    return stringTypes.firstWhereOrNull((e) => e.label == label)?.id ??
        'nickel';
  }

  String resolveStringTypeLabel(String id) {
    return stringTypes.firstWhereOrNull((e) => e.id == id)?.label ??
        'Nickel Wound';
  }

  List<String> getStringNames(
    String instrument,
    int stringCount,
    String tuningId,
  ) {
    final tuning = tuningList.firstWhereOrNull((e) => e.id == tuningId);
    final base6 = tuning?.names6 ?? const ['e', 'B', 'G', 'D', 'A', 'E'];

    if (instrument == 'bass') {
      return bassStringNames[stringCount] ?? bassStringNames[4]!;
    }
    if (stringCount == 7) {
      return [...base6, 'B'];
    }
    if (stringCount == 8) {
      return [...base6, 'B', 'F#'];
    }
    return base6;
  }

  List<double> getStringFreqs(
    String instrument,
    int stringCount,
    String tuningId,
  ) {
    final tuning =
        tuningList.firstWhereOrNull((e) => e.id == tuningId) ??
        tuningList.first;
    final base6 = tuning.notes;

    if (instrument == 'bass') {
      final base = <int, List<double>>{
        4: [196.0, 146.83, 110.0, 82.41],
        5: [196.0, 146.83, 110.0, 82.41, 61.74],
        6: [261.63, 196.0, 146.83, 110.0, 82.41, 61.74],
      };
      final semitoneOffset =
          (12 * math.log((tuning.notes[5]) / 164.81) / math.ln2).round();
      final st = math.pow(2.0, 1 / 12).toDouble();
      return (base[stringCount] ?? base[4]!)
          .map((f) => f * math.pow(st, semitoneOffset).toDouble())
          .toList();
    }

    if (stringCount == 7) {
      final st = math.pow(2.0, 1 / 12).toDouble();
      return [...base6, base6[5] * math.pow(st, -5).toDouble()];
    }

    if (stringCount == 8) {
      final st = math.pow(2.0, 1 / 12).toDouble();
      return [
        ...base6,
        base6[5] * math.pow(st, -5).toDouble(),
        base6[5] * math.pow(st, -10).toDouble(),
      ];
    }
    return base6;
  }

  // ---------- Calculator ----------

  void changeCalcInstrument(bool isGuitar) {
    calcInstrument = isGuitar ? 'guitar' : 'bass';
    calcStringCount = isGuitar ? 6 : 4;
    calcScaleLength = isGuitar ? 25.5 : 34.0;
    calcStringScales = List.filled(calcStringCount, calcScaleLength);

    final gauges = calcInstrument == 'bass'
        ? defaultBassGauges[calcStringCount]!
        : defaultGuitarGauges[calcStringCount]!;
    final wounds = calcInstrument == 'bass'
        ? defaultWoundBass[calcStringCount]!
        : defaultWoundGuitar[calcStringCount]!;

    calcGauges = [...gauges];
    calcWounds = [...wounds];
    _recalcCalc();
    update();
  }

  void changeCalcStringCount(int value) {
    if (calcInstrument == 'guitar') {
      calcStringCount = value.clamp(6, 8);
    } else {
      calcStringCount = value.clamp(4, 6);
    }

    calcStringScales = List.filled(calcStringCount, calcScaleLength);
    final gauges = calcInstrument == 'bass'
        ? defaultBassGauges[calcStringCount]!
        : defaultGuitarGauges[calcStringCount]!;
    final wounds = calcInstrument == 'bass'
        ? defaultWoundBass[calcStringCount]!
        : defaultWoundGuitar[calcStringCount]!;

    calcGauges = [...gauges];
    calcWounds = [...wounds];
    _recalcCalc();
    update();
  }

  void setCalcScale(double scale) {
    calcScaleLength = scale;
    _recalcCalc();
    update();
  }

  void setCalcStringScale(int index, double scale) {
    if (index >= calcStringScales.length) return;
    calcStringScales[index] = scale;
    _recalcCalc();
    update();
  }

  void setCalcMultiScale(bool value) {
    calcMultiScale = value;
    _recalcCalc();
    update();
  }

  void setCalcTuningByLabel(String label) {
    calcTuning = resolveTuningId(label);
    _recalcCalc();
    update();
  }

  void setStringTypeByLabel(String label) {
    stringType = resolveStringTypeId(label);
    _recalcCalc();
    _recalcSrc();
    _recalcTgt();
    if (buildResult != null) {
      generateBuild();
    }
    update();
  }

  void bumpCalcGauge(int index, int dir) {
    if (index >= calcGauges.length) return;
    calcGauges[index] = _bumpGauge(calcGauges[index], calcWounds[index], dir);
    _recalcCalc();
    update();
  }

  void toggleCalcWound(int index, bool wound) {
    if (index >= calcWounds.length) return;
    calcWounds[index] = wound;
    calcGauges[index] = _nearestStep(calcGauges[index], wound);
    _recalcCalc();
    update();
  }

  void _recalcCalc() {
    final freqs = getStringFreqs(calcInstrument, calcStringCount, calcTuning);
    final scales = calcMultiScale
        ? calcStringScales.take(calcStringCount).toList()
        : List.filled(calcStringCount, calcScaleLength);

    calcTensions = List.generate(calcStringCount, (i) {
      return _calcTension(
        calcGauges[i],
        calcWounds[i],
        scales[i],
        freqs[i],
        stringTypeMult,
      );
    });
  }

  double get calcTotalTension =>
      calcTensions.fold<double>(0.0, (a, b) => a + b);

  // ---------- Match ----------

  void setMatchInstrument(bool isGuitar) {
    srcInstrument = isGuitar ? 'guitar' : 'bass';
    srcStringCount = isGuitar ? 6 : 4;
    srcScale = isGuitar ? 25.5 : 34.0;
    srcScales = List.filled(srcStringCount, srcScale);
    srcTuning = 'E';
    srcGauges = srcInstrument == 'bass'
        ? [...defaultBassGauges[srcStringCount]!]
        : [...defaultGuitarGauges[srcStringCount]!];
    srcWounds = srcInstrument == 'bass'
        ? [...defaultWoundBass[srcStringCount]!]
        : [...defaultWoundGuitar[srcStringCount]!];

    tgtScale = srcScale;
    tgtScales = List.filled(srcStringCount, srcScale);
    tgtWounds = [...srcWounds];
    tgtGauges = [];
    matchGenerated = false;

    _recalcSrc();
    _recalcTgt();
    update();
  }

  void changeMatchStringCount(int value) {
    srcStringCount = srcInstrument == 'guitar'
        ? value.clamp(6, 8)
        : value.clamp(4, 6);
    srcScales = List.filled(srcStringCount, srcScale);
    srcGauges = srcInstrument == 'bass'
        ? [...defaultBassGauges[srcStringCount]!]
        : [...defaultGuitarGauges[srcStringCount]!];
    srcWounds = srcInstrument == 'bass'
        ? [...defaultWoundBass[srcStringCount]!]
        : [...defaultWoundGuitar[srcStringCount]!];
    tgtScales = List.filled(srcStringCount, tgtScale);
    tgtWounds = [...srcWounds];
    tgtGauges = [];
    matchGenerated = false;
    _recalcSrc();
    update();
  }

  void setMatchScale(double scale) {
    srcScale = scale;
    _recalcSrc();
    update();
  }

  void setMatchScaleAt(int index, double scale) {
    if (index >= srcScales.length) return;
    srcScales[index] = scale;
    _recalcSrc();
    update();
  }

  void setMatchMultiScale(bool value) {
    srcMultiScale = value;
    _recalcSrc();
    update();
  }

  void setMatchTuningByLabel(String label) {
    srcTuning = resolveTuningId(label);
    _recalcSrc();
    update();
  }

  void bumpSrcGauge(int index, int dir) {
    srcGauges[index] = _bumpGauge(srcGauges[index], srcWounds[index], dir);
    matchGenerated = false;
    _recalcSrc();
    update();
  }

  void toggleSrcWound(int index, bool wound) {
    srcWounds[index] = wound;
    srcGauges[index] = _nearestStep(srcGauges[index], wound);
    matchGenerated = false;
    _recalcSrc();
    update();
  }

  void setTargetTuningByLabel(String label) {
    tgtTuning = resolveTuningId(label);
    _recalcTgt();
    update();
  }

  void setTargetScale(double value) {
    tgtScale = value;
    _recalcTgt();
    update();
  }

  void setTargetMultiScale(bool value) {
    tgtMultiScale = value;
    _recalcTgt();
    update();
  }

  void setTargetScaleAt(int index, double scale) {
    if (index >= tgtScales.length) return;
    tgtScales[index] = scale;
    _recalcTgt();
    update();
  }

  void bumpTgtGauge(int index, int dir) {
    if (index >= tgtGauges.length) return;
    tgtGauges[index] = _bumpGauge(tgtGauges[index], tgtWounds[index], dir);
    _recalcTgt();
    update();
  }

  void toggleTgtWound(int index, bool wound) {
    if (index >= tgtWounds.length) return;
    tgtWounds[index] = wound;
    if (index < tgtGauges.length) {
      tgtGauges[index] = _nearestStep(tgtGauges[index], wound);
    }
    _recalcTgt();
    update();
  }

  void generateMatchFeel() {
    final n = srcStringCount;
    final isBass = srcInstrument == 'bass';
    final freqs = getStringFreqs(srcInstrument, n, tgtTuning);
    final scales = tgtMultiScale
        ? tgtScales.take(n).toList()
        : List.filled(n, tgtScale);
    final plainMult = isBass ? 1.0 : 0.85;

    final results = List.generate(n, (i) {
      final target = srcTensions.length > i ? srcTensions[i] : 15.0;
      return _solveStringAuto(
        target,
        scales[i],
        freqs[i],
        isBass,
        i,
        plainMult,
        stringTypeMult,
      );
    });

    tgtWounds = results.map((e) => e.wound).toList();
    tgtGauges = results.map((e) => e.gauge).toList();
    matchGenerated = true;
    _recalcTgt();
    update();
  }

  void _recalcSrc() {
    final freqs = getStringFreqs(srcInstrument, srcStringCount, srcTuning);
    final scales = srcMultiScale
        ? srcScales.take(srcStringCount).toList()
        : List.filled(srcStringCount, srcScale);

    srcTensions = List.generate(srcStringCount, (i) {
      return _calcTension(
        srcGauges[i],
        srcWounds[i],
        scales[i],
        freqs[i],
        stringTypeMult,
      );
    });
  }

  void _recalcTgt() {
    if (tgtGauges.isEmpty) {
      tgtTensions = [];
      return;
    }

    final n = srcStringCount;
    final freqs = getStringFreqs(srcInstrument, n, tgtTuning);
    final scales = tgtMultiScale
        ? tgtScales.take(n).toList()
        : List.filled(n, tgtScale);

    tgtTensions = List.generate(n, (i) {
      return _calcTension(
        tgtGauges[i],
        tgtWounds[i],
        scales[i],
        freqs[i],
        stringTypeMult,
      );
    });
  }

  // ---------- Build ----------

  void setBuildInstrument(bool isGuitar) {
    buildInstrument = isGuitar ? 'guitar' : 'bass';
    buildStringCount = isGuitar ? 6 : 4;
    buildSingleScale = isGuitar ? 25.5 : 34.0;
    buildScales = List.filled(buildStringCount, buildSingleScale);
    buildResult = null;
    update();
  }

  void setBuildStringCount(int count) {
    buildStringCount = buildInstrument == 'guitar'
        ? count.clamp(6, 8)
        : count.clamp(4, 6);
    buildScales = List.filled(buildStringCount, buildSingleScale);
    buildResult = null;
    update();
  }

  void setBuildTuningByLabel(String label) {
    buildTuning = resolveTuningId(label);
    buildResult = null;
    update();
  }

  void setBuildStringScale(int index, double scale) {
    if (index >= buildScales.length) return;
    buildScales[index] = scale;
    buildResult = null;
    update();
  }

  void setBuildSingleScale(double scale) {
    buildSingleScale = scale;
    buildResult = null;
    update();
  }

  void setBuildMultiScale(bool value) {
    buildMultiScale = value;
    buildResult = null;
    update();
  }

  void setBuildFeel(String feelId) {
    buildFeelId = feelId;
    buildResult = null;
    update();
  }

  void generateBuild() {
    final targetByFeel = {'loose': 13.0, 'balanced': 15.5, 'tight': 18.0};

    final target = targetByFeel[buildFeelId];
    if (target == null) return;

    final isBass = buildInstrument == 'bass';
    final freqs = getStringFreqs(
      buildInstrument,
      buildStringCount,
      buildTuning,
    );
    final scales = buildMultiScale
        ? buildScales.take(buildStringCount).toList()
        : List.filled(buildStringCount, buildSingleScale);
    final plainMult = isBass ? 1.0 : 0.85;

    final result = List.generate(buildStringCount, (i) {
      return _solveStringAuto(
        target,
        scales[i],
        freqs[i],
        isBass,
        i,
        plainMult,
        stringTypeMult,
      );
    });

    final gauges = result.map((e) => e.gauge).toList();
    final wounds = result.map((e) => e.wound).toList();
    final tensions = List.generate(buildStringCount, (i) {
      return _calcTension(
        gauges[i],
        wounds[i],
        scales[i],
        freqs[i],
        stringTypeMult,
      );
    });
    final names = getStringNames(
      buildInstrument,
      buildStringCount,
      buildTuning,
    );

    buildResult = ComputedSetup(
      instrument: buildInstrument,
      stringCount: buildStringCount,
      tuning: buildTuning,
      gauges: gauges,
      wounds: wounds,
      tensions: tensions,
      scales: scales,
      stringNames: names,
    );
    update();
  }

  void loadBuildResultIntoCalculator() {
    final result = buildResult;
    if (result == null) return;

    calcInstrument = result.instrument;
    calcStringCount = result.stringCount;
    calcGauges = [...result.gauges];
    calcWounds = [...result.wounds];
    calcTuning = result.tuning;

    final allSameScale = result.scales.every(
      (s) => (s - result.scales.first).abs() < 0.001,
    );
    calcMultiScale = !allSameScale;
    calcScaleLength = result.scales.first;
    calcStringScales = [...result.scales];

    _recalcCalc();
    update();
  }

  void syncBuildResultFromCalculator() {
    final scales = calcMultiScale
        ? calcStringScales.take(calcStringCount).toList()
        : List.filled(calcStringCount, calcScaleLength);

    final gauges = calcGauges.take(calcStringCount).toList();
    final wounds = calcWounds.take(calcStringCount).toList();
    final tensions = calcTensions.take(calcStringCount).toList();

    buildInstrument = calcInstrument;
    buildStringCount = calcStringCount;
    buildTuning = calcTuning;
    buildMultiScale = calcMultiScale;
    buildSingleScale = calcScaleLength;
    buildScales = [...scales];

    buildResult = ComputedSetup(
      instrument: calcInstrument,
      stringCount: calcStringCount,
      tuning: calcTuning,
      gauges: gauges,
      wounds: wounds,
      tensions: tensions,
      scales: scales,
      stringNames: getStringNames(calcInstrument, calcStringCount, calcTuning),
    );

    final avg = tensions.isEmpty
        ? 15.5
        : tensions.fold<double>(0, (a, b) => a + b) / tensions.length;
    if (avg < 14.5) {
      buildFeelId = 'loose';
    } else if (avg < 17.0) {
      buildFeelId = 'balanced';
    } else {
      buildFeelId = 'tight';
    }

    update();
  }

  void loadMatchResultIntoCalculator() {
    final hasMatchedResult = matchGenerated && tgtGauges.isNotEmpty;
    final count = hasMatchedResult ? tgtGauges.length : srcStringCount;
    final gauges = hasMatchedResult ? tgtGauges : srcGauges;
    final wounds = hasMatchedResult ? tgtWounds : srcWounds;
    final tuning = hasMatchedResult ? tgtTuning : srcTuning;
    final multiScale = hasMatchedResult ? tgtMultiScale : srcMultiScale;
    final singleScale = hasMatchedResult ? tgtScale : srcScale;
    final scales = hasMatchedResult ? tgtScales : srcScales;

    calcInstrument = srcInstrument;
    calcStringCount = count;
    calcGauges = gauges.take(count).toList();
    calcWounds = wounds.take(count).toList();
    calcTuning = tuning;
    calcMultiScale = multiScale;
    calcScaleLength = singleScale;
    calcStringScales = multiScale
        ? scales.take(count).toList()
        : List.filled(count, singleScale);

    _recalcCalc();
    update();
  }

  void syncMatchResultFromCalculator() {
    final count = calcStringCount;
    final scales = calcMultiScale
        ? calcStringScales.take(count).toList()
        : List.filled(count, calcScaleLength);

    tgtTuning = calcTuning;
    tgtMultiScale = calcMultiScale;
    tgtScale = calcScaleLength;
    tgtScales = [...scales];
    tgtGauges = calcGauges.take(count).toList();
    tgtWounds = calcWounds.take(count).toList();
    tgtTensions = calcTensions.take(count).toList();
    matchGenerated = true;

    update();
  }

  // ---------- Artist ----------

  void setArtistFilter(String value) {
    artistFilter = value;
    update();
  }

  void setArtistSearch(String value) {
    artistSearch = value;
    update();
  }

  void loadArtist(ArtistTuningEntry artist) {
    selectedArtist = artist;
    artistEditedGauges = null;
    artistEditedWounds = null;
    artistEditedTensions = null;
    artistEditedScales = null;
    artistEditedTuning = null;
    artistEditedInstrument = null;

    final parsed = _parseArtistGauges(artist.gauges);
    calcInstrument = artist.instrument == 'bass' ? 'bass' : 'guitar';
    calcStringCount = parsed.values.length;
    calcGauges = parsed.values;
    calcWounds = parsed.wounds;
    calcScaleLength = artist.scaleLength;
    calcStringScales = List.filled(calcStringCount, calcScaleLength);
    calcTuning = tuningList.any((t) => t.id == artist.tuning)
        ? artist.tuning
        : 'E';
    calcMultiScale = false;

    _recalcCalc();
    update();
  }

  bool get artistHasEditedSetup =>
      artistEditedGauges != null &&
      artistEditedWounds != null &&
      artistEditedTensions != null &&
      artistEditedScales != null &&
      artistEditedTuning != null &&
      artistEditedInstrument != null;

  void loadArtistSetupIntoCalculator() {
    final artist = selectedArtist;
    if (artist == null) return;

    if (artistHasEditedSetup) {
      final editedCount = artistEditedGauges!.length;
      calcInstrument = artistEditedInstrument!;
      calcStringCount = editedCount;
      calcGauges = [...artistEditedGauges!];
      calcWounds = [...artistEditedWounds!];
      calcTuning = artistEditedTuning!;
      final allSameScale = artistEditedScales!.every(
        (s) => (s - artistEditedScales!.first).abs() < 0.001,
      );
      calcMultiScale = !allSameScale;
      calcScaleLength = artistEditedScales!.first;
      calcStringScales = [...artistEditedScales!];
      _recalcCalc();
      update();
      return;
    }

    final parsed = _parseArtistGauges(artist.gauges);
    calcInstrument = artist.instrument == 'bass' ? 'bass' : 'guitar';
    calcStringCount = parsed.values.length;
    calcGauges = [...parsed.values];
    calcWounds = [...parsed.wounds];
    calcTuning = tuningList.any((t) => t.id == artist.tuning)
        ? artist.tuning
        : 'E';
    calcScaleLength = artist.scaleLength;
    calcMultiScale = false;
    calcStringScales = List.filled(calcStringCount, calcScaleLength);
    _recalcCalc();
    update();
  }

  void syncArtistSetupFromCalculator() {
    final artist = selectedArtist;
    if (artist == null) return;

    final count = calcStringCount;
    final scales = calcMultiScale
        ? calcStringScales.take(count).toList()
        : List.filled(count, calcScaleLength);

    artistEditedInstrument = calcInstrument;
    artistEditedTuning = calcTuning;
    artistEditedGauges = calcGauges.take(count).toList();
    artistEditedWounds = calcWounds.take(count).toList();
    artistEditedTensions = calcTensions.take(count).toList();
    artistEditedScales = scales;
    update();
  }

  List<double> computeArtistTensions(ArtistTuningEntry artist) {
    final parsed = _parseArtistGauges(artist.gauges);
    final instrument = artist.instrument == 'bass' ? 'bass' : 'guitar';
    final freqs = getStringFreqs(
      instrument,
      parsed.values.length,
      artist.tuning,
    );

    return List.generate(parsed.values.length, (i) {
      return _calcTension(
        parsed.values[i],
        parsed.wounds[i],
        artist.scaleLength,
        freqs[i],
        stringTypeMult,
      );
    });
  }

  // ---------- Save/load ----------

  Future<SaveSetupResult> saveFromCalculator([String? customName]) async {
    return _saveSetup(
      name: customName,
      instrument: calcInstrument,
      stringCount: calcStringCount,
      gauges: calcGauges,
      wounds: calcWounds,
      scale: calcMultiScale
          ? calcStringScales
                .take(calcStringCount)
                .map((s) => s.toStringAsFixed(2))
                .join(',')
          : calcScaleLength.toStringAsFixed(2),
      tuning: calcTuning,
    );
  }

  Future<SaveSetupResult> saveFromBuild([String? customName]) async {
    final result = buildResult;
    if (result == null) return SaveSetupResult.invalid;

    return _saveSetup(
      name: customName,
      instrument: result.instrument,
      stringCount: result.stringCount,
      gauges: result.gauges,
      wounds: result.wounds,
      scale: buildMultiScale
          ? result.scales.map((s) => s.toStringAsFixed(2)).join(',')
          : buildSingleScale.toStringAsFixed(2),
      tuning: result.tuning,
    );
  }

  Future<SaveSetupResult> saveFromMatch([String? customName]) async {
    final gauges = tgtGauges.isNotEmpty ? tgtGauges : srcGauges;
    final wounds = tgtGauges.isNotEmpty ? tgtWounds : srcWounds;

    return _saveSetup(
      name: customName,
      instrument: srcInstrument,
      stringCount: srcStringCount,
      gauges: gauges,
      wounds: wounds,
      scale: tgtMultiScale
          ? tgtScales
                .take(srcStringCount)
                .map((s) => s.toStringAsFixed(2))
                .join(',')
          : tgtScale.toStringAsFixed(2),
      tuning: tgtTuning,
    );
  }

  Future<SaveSetupResult> _saveSetup({
    required String? name,
    required String instrument,
    required int stringCount,
    required List<String> gauges,
    required List<bool> wounds,
    required String scale,
    required String tuning,
  }) async {
    final cleanGauges = gauges.take(stringCount).map((g) => g.trim()).toList();
    final cleanWounds = wounds.take(stringCount).toList();

    if (!_isValidSetupPayload(
      stringCount: stringCount,
      gauges: cleanGauges,
      wounds: cleanWounds,
      scale: scale,
    )) {
      return SaveSetupResult.invalid;
    }

    final normalizedScale = _normalizeScaleString(scale);
    final isDuplicate = savedSetups.any((existing) {
      return _buildSetupFingerprint(
            instrument: existing.instrument,
            stringCount: existing.stringCount,
            gauges: existing.gauges,
            wounds: existing.woundFlags,
            scale: existing.scaleLength,
            tuning: existing.tuning,
          ) ==
          _buildSetupFingerprint(
            instrument: instrument,
            stringCount: stringCount,
            gauges: cleanGauges,
            wounds: cleanWounds,
            scale: normalizedScale,
            tuning: tuning,
          );
    });

    if (isDuplicate) {
      return SaveSetupResult.duplicate;
    }

    final setup = SavedSetup(
      id: DateTime.now().millisecondsSinceEpoch,
      name: (name == null || name.trim().isEmpty)
          ? 'Setup ${savedSetups.length + 1}'
          : name.trim(),
      instrument: instrument,
      stringCount: stringCount,
      gauges: cleanGauges,
      woundFlags: cleanWounds,
      scaleLength: normalizedScale,
      tuning: tuning,
      savedAt: _todayString(),
    );

    savedSetups = [setup, ...savedSetups].take(10).toList();
    await _persistSavedSetups();
    update();
    return SaveSetupResult.saved;
  }

  Future<void> deleteSetup(int id) async {
    savedSetups.removeWhere((e) => e.id == id);
    await _persistSavedSetups();
    update();
  }

  Future<void> renameSetup(int id, String name) async {
    if (name.trim().isEmpty) return;
    savedSetups = savedSetups
        .map(
          (e) => e.id == id
              ? SavedSetup(
                  id: e.id,
                  name: name.trim(),
                  instrument: e.instrument,
                  stringCount: e.stringCount,
                  gauges: e.gauges,
                  woundFlags: e.woundFlags,
                  scaleLength: e.scaleLength,
                  tuning: e.tuning,
                  savedAt: e.savedAt,
                )
              : e,
        )
        .toList();
    await _persistSavedSetups();
    update();
  }

  void loadSavedSetup(SavedSetup setup) {
    calcInstrument = setup.instrument;
    calcStringCount = setup.stringCount;
    calcGauges = [...setup.gauges];
    calcWounds = [...setup.woundFlags];
    calcTuning = setup.tuning;

    final split = setup.scaleLength.split(',');
    if (split.length > 1) {
      calcMultiScale = true;
      calcStringScales = split
          .map((e) => double.tryParse(e.trim()) ?? 25.5)
          .toList();
      calcScaleLength = calcStringScales.isEmpty
          ? 25.5
          : calcStringScales.first;
    } else {
      calcMultiScale = false;
      calcScaleLength = double.tryParse(setup.scaleLength) ?? 25.5;
      calcStringScales = List.filled(calcStringCount, calcScaleLength);
    }

    srcInstrument = calcInstrument;
    srcStringCount = calcStringCount;
    srcGauges = [...calcGauges];
    srcWounds = [...calcWounds];
    srcTuning = calcTuning;
    srcScale = calcScaleLength;
    srcScales = [...calcStringScales];
    srcMultiScale = calcMultiScale;

    matchGenerated = false;
    _recalcCalc();
    _recalcSrc();
    update();
  }

  // ---------- Shop ----------

  void prepareShop({
    required List<String> gauges,
    required List<bool> wounds,
    String packName = '',
  }) {
    shopGauges = [...gauges];
    shopWounds = [...wounds];
    shopPackName = packName;
    update();
  }

  List<StringPack> get closestShopPacks {
    if (shopGauges.isEmpty) return [];

    final matches =
        stringPacks
            .where((pack) => pack.gauges.length == shopGauges.length)
            .map(
              (pack) =>
                  MapEntry(pack, _scorePackMatch(pack.gauges, shopGauges)),
            )
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));

    return matches.take(4).map((e) => e.key).toList();
  }

  // ---------- Math ----------

  static const double _uwPlainCoeff = 0.2215;

  static const Map<int, double> _uwWound = {
    17: 0.000082571,
    18: 0.000093170,
    19: 0.000104030,
    20: 0.000114600,
    21: 0.000125860,
    22: 0.000131980,
    24: 0.000154700,
    26: 0.000126790,
    28: 0.000177040,
    30: 0.000203940,
    32: 0.000225290,
    34: 0.000238870,
    36: 0.000239412,
    38: 0.000277890,
    40: 0.000306450,
    42: 0.000336870,
    44: 0.000358980,
    46: 0.000382803,
    48: 0.000398240,
    50: 0.000416520,
    52: 0.000453890,
    54: 0.000487370,
    56: 0.000524750,
    58: 0.000562350,
    60: 0.000600840,
    62: 0.000641200,
    64: 0.000683200,
    66: 0.000726600,
    68: 0.000771300,
    70: 0.000817800,
    72: 0.000866000,
    74: 0.000916000,
    76: 0.000967700,
    80: 0.001072000,
    85: 0.001216000,
    90: 0.001367000,
    95: 0.001525000,
    100: 0.001690000,
    105: 0.001862000,
    110: 0.002042000,
  };

  double _getUw(String gauge, bool isWound, double stringTypeMult) {
    final d = double.tryParse(gauge) ?? 0;
    if (d <= 0) return 0;

    if (!isWound) {
      return _uwPlainCoeff * d * d;
    }

    final thou = (d * 1000).round();
    final direct = _uwWound[thou];
    if (direct != null) {
      return direct * stringTypeMult;
    }

    final keys = _uwWound.keys.toList()..sort();
    int? lo;
    int? hi;
    for (final key in keys) {
      if (key <= thou) {
        lo = key;
      }
      if (key >= thou) {
        hi = key;
        break;
      }
    }

    if (lo == null && hi == null) return 0;
    if (lo == null) return (_uwWound[hi!] ?? 0) * stringTypeMult;
    if (hi == null) return (_uwWound[lo] ?? 0) * stringTypeMult;
    if (lo == hi) return (_uwWound[lo] ?? 0) * stringTypeMult;

    final t = (thou - lo) / (hi - lo);
    final uw = (_uwWound[lo]! + t * (_uwWound[hi]! - _uwWound[lo]!));
    return uw * stringTypeMult;
  }

  double _calcTension(
    String gauge,
    bool isWound,
    double scaleInches,
    double freqHz,
    double stringTypeMult,
  ) {
    final uw = _getUw(gauge, isWound, stringTypeMult);
    if (uw <= 0 || freqHz <= 0) return 0;
    final tension = uw * math.pow(2 * scaleInches * freqHz, 2) / 386.4;
    return (tension * 10).round() / 10;
  }

  String _bumpGauge(String value, bool wound, int dir) {
    final steps = wound ? woundSteps : plainSteps;
    final clean = value.replaceAll(RegExp(r'[wp]$'), '');
    var index = steps.indexOf(clean);
    if (index < 0) {
      index = _nearestStepIndex(clean, steps);
    }
    final next = (index + dir).clamp(0, steps.length - 1);
    return steps[next];
  }

  String _nearestStep(String value, bool wound) {
    final steps = wound ? woundSteps : plainSteps;
    final clean = value.replaceAll(RegExp(r'[wp]$'), '');
    return steps[_nearestStepIndex(clean, steps)];
  }

  int _nearestStepIndex(String value, List<String> steps) {
    final current = double.tryParse(value) ?? 0.01;
    var bestIndex = 0;
    var bestDiff = double.infinity;
    for (var i = 0; i < steps.length; i++) {
      final diff = (double.tryParse(steps[i]) ?? 0 - current).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  _SolvedString _solveStringAuto(
    double targetT,
    double scaleIn,
    double freqHz,
    bool isBass,
    int stringPos,
    double plainMult,
    double stMult,
  ) {
    if (isBass) {
      return _SolvedString(
        gauge: _solveGauge(targetT, true, scaleIn, freqHz, stMult),
        wound: true,
      );
    }

    if (stringPos <= 1) {
      return _SolvedString(
        gauge: _solveGauge(targetT * plainMult, false, scaleIn, freqHz, stMult),
        wound: false,
      );
    }

    final plainTarget = targetT * plainMult;
    final pGauge = _solveGauge(plainTarget, false, scaleIn, freqHz, stMult);
    final wGauge = _solveGauge(targetT, true, scaleIn, freqHz, stMult);

    final pD = double.tryParse(pGauge) ?? 0;
    final wD = double.tryParse(wGauge) ?? 0;

    if (pD > 0.020) return _SolvedString(gauge: wGauge, wound: true);
    if (wD < 0.017) return _SolvedString(gauge: pGauge, wound: false);

    final pT = _calcTension(pGauge, false, scaleIn, freqHz, stMult);
    final wT = _calcTension(wGauge, true, scaleIn, freqHz, stMult);

    if ((wT - targetT).abs() < (pT - plainTarget).abs()) {
      return _SolvedString(gauge: wGauge, wound: true);
    }
    return _SolvedString(gauge: pGauge, wound: false);
  }

  String _solveGauge(
    double target,
    bool isWound,
    double scaleIn,
    double freqHz,
    double stMult,
  ) {
    if (!isWound) {
      final raw = math.sqrt(
        target * 386.4 / (_uwPlainCoeff * math.pow(2 * scaleIn * freqHz, 2)),
      );
      return _nearestStep(raw.toString(), false);
    }

    String best = woundSteps.first;
    var bestDiff = double.infinity;
    for (final step in woundSteps) {
      final t = _calcTension(step, true, scaleIn, freqHz, stMult);
      final diff = (t - target).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = step;
      }
    }
    return best;
  }

  _ParsedGauges _parseArtistGauges(List<String> gauges) {
    final values = <String>[];
    final wounds = <bool>[];
    for (final gauge in gauges) {
      final isWound = gauge.endsWith('w');
      values.add(gauge.replaceAll(RegExp(r'[wp]$'), ''));
      wounds.add(isWound);
    }
    return _ParsedGauges(values: values, wounds: wounds);
  }

  double _scorePackMatch(List<String> packGauges, List<String> targetGauges) {
    if (packGauges.length != targetGauges.length) return double.infinity;

    var score = 0.0;
    for (var i = 0; i < packGauges.length; i++) {
      final p =
          double.tryParse(packGauges[i].replaceAll(RegExp(r'[wp]'), '')) ?? 0;
      final t =
          double.tryParse(targetGauges[i].replaceAll(RegExp(r'[wp]'), '')) ?? 0;
      score += (p - t).abs();
    }
    return score;
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool _isValidSetupPayload({
    required int stringCount,
    required List<String> gauges,
    required List<bool> wounds,
    required String scale,
  }) {
    if (stringCount <= 0) return false;
    if (gauges.length != stringCount || wounds.length != stringCount) {
      return false;
    }
    if (gauges.any((g) => g.isEmpty || (double.tryParse(g) ?? 0) <= 0)) {
      return false;
    }

    final scales = scale.split(',').map((part) => part.trim()).toList();
    if (scales.any(
      (value) => value.isEmpty || (double.tryParse(value) ?? 0) <= 0,
    )) {
      return false;
    }
    return scales.length == 1 || scales.length == stringCount;
  }

  String _normalizeScaleString(String scale) {
    final pieces = scale
        .split(',')
        .map((s) => (double.tryParse(s.trim()) ?? 25.5).toStringAsFixed(2))
        .toList();
    return pieces.join(',');
  }

  String _buildSetupFingerprint({
    required String instrument,
    required int stringCount,
    required List<String> gauges,
    required List<bool> wounds,
    required String scale,
    required String tuning,
  }) {
    final normalizedGauges = gauges
        .take(stringCount)
        .map((g) => (double.tryParse(g.trim()) ?? 0).toStringAsFixed(3))
        .join('|');
    final normalizedWounds = wounds
        .take(stringCount)
        .map((w) => w ? '1' : '0')
        .join('|');
    final normalizedScale = _normalizeScaleString(scale);

    return [
      instrument.trim().toLowerCase(),
      stringCount.toString(),
      tuning.trim().toLowerCase(),
      normalizedScale,
      normalizedGauges,
      normalizedWounds,
    ].join('::');
  }
}

class _SolvedString {
  const _SolvedString({required this.gauge, required this.wound});

  final String gauge;
  final bool wound;
}

class _ParsedGauges {
  const _ParsedGauges({required this.values, required this.wounds});

  final List<String> values;
  final List<bool> wounds;
}
