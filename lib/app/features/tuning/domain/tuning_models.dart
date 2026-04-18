class TuningDefinition {
  const TuningDefinition({
    required this.id,
    required this.label,
    required this.group,
    required this.names6,
    required this.notes,
  });

  final String id;
  final String label;
  final String group;
  final List<String> names6;
  final List<double> notes;
}

class StringTypeDefinition {
  const StringTypeDefinition({
    required this.id,
    required this.label,
    required this.mult,
  });

  final String id;
  final String label;
  final double mult;
}

class ArtistTuningEntry {
  const ArtistTuningEntry({
    required this.name,
    required this.band,
    required this.era,
    required this.tuning,
    required this.gauges,
    required this.scaleLength,
    required this.notes,
    required this.verified,
    required this.genre,
    this.instrument = 'guitar',
    this.perStringScales,
    this.legendId,
    this.totalStringsApi,
    this.stringTypeApi,
    this.isMultiScaleApi,
    this.selectedTuningRaw,
    this.totalTensionApi,
    this.apiStringTensions,
  });

  final String name;
  final String band;
  final String era;
  final String tuning;
  final List<String> gauges;
  final double scaleLength;
  final String notes;
  final bool verified;
  final String genre;
  final String instrument;
  /// When set (e.g. legend API multi-scale), overrides single [scaleLength] per string.
  final List<double>? perStringScales;

  /// Legend library API (`/users/legent-librarys/`) — optional; null for bundled artist data.
  final int? legendId;
  final int? totalStringsApi;
  final String? stringTypeApi;
  final bool? isMultiScaleApi;
  final String? selectedTuningRaw;
  final String? totalTensionApi;
  /// Per-string tension values from API when available.
  final List<double>? apiStringTensions;

  /// GET `/users/legent-librarys/` item (same shape as user library entries + `category`).
  factory ArtistTuningEntry.fromLegendApi(
    Map<String, dynamic> json,
    String tuningId,
  ) {
    final strings = (json['strings'] as List?) ?? [];
    final gaugeList = <String>[];
    for (final s in strings) {
      final m = Map<String, dynamic>.from(s as Map);
      final g = m['gauge']?.toString() ?? '';
      final w = m['type']?.toString().toLowerCase() == 'w';
      gaugeList.add('$g${w ? 'w' : 'p'}');
    }
    final multi = json['is_multi_scale'] == true;
    final baseScale =
        double.tryParse((json['scale_sength'] ?? '25.5').toString()) ?? 25.5;
    List<double>? perStringScales;
    if (multi && strings.isNotEmpty) {
      perStringScales =
          strings.map((s) {
            final m = Map<String, dynamic>.from(s as Map);
            return double.tryParse(m['scale']?.toString() ?? '') ?? baseScale;
          }).toList();
    }

    final idVal = json['id'];
    final legendId = idVal is int ? idVal : int.tryParse('$idVal');

    List<double>? apiTensions;
    if (strings.isNotEmpty) {
      apiTensions =
          strings.map((s) {
            final m = Map<String, dynamic>.from(s as Map);
            return double.tryParse(m['tension']?.toString() ?? '') ?? 0.0;
          }).toList();
      if (apiTensions.length != gaugeList.length) {
        apiTensions = null;
      }
    }

    return ArtistTuningEntry(
      name: json['setup_name']?.toString() ?? 'Setup',
      band: json['category']?.toString() ?? '',
      era: json['total_tension'] != null ? '${json['total_tension']} lbs' : '',
      tuning: tuningId,
      gauges: gaugeList,
      scaleLength: baseScale,
      notes: '',
      verified: json['is_varified'] == true,
      genre: json['category']?.toString() ?? '',
      instrument:
          json['instrument_type']?.toString() == 'bass' ? 'bass' : 'guitar',
      perStringScales: perStringScales,
      legendId: legendId,
      totalStringsApi: (json['total_strings'] as int?) ?? gaugeList.length,
      stringTypeApi: json['string_type']?.toString(),
      isMultiScaleApi: json['is_multi_scale'] == true,
      selectedTuningRaw: json['selected_tuning']?.toString(),
      totalTensionApi: json['total_tension']?.toString(),
      apiStringTensions: apiTensions,
    );
  }
}

class StringPack {
  const StringPack({
    required this.id,
    required this.brand,
    required this.line,
    required this.name,
    required this.type,
    required this.gauges,
    required this.barcode,
  });

  final String id;
  final String brand;
  final String line;
  final String name;
  final String type;
  final List<String> gauges;
  final String barcode;
}

class SavedSetup {
  const SavedSetup({
    required this.id,
    required this.name,
    required this.instrument,
    required this.stringCount,
    required this.gauges,
    required this.woundFlags,
    required this.scaleLength,
    required this.tuning,
    required this.savedAt,
  });

  final int id;
  final String name;
  final String instrument;
  final int stringCount;
  final List<String> gauges;
  final List<bool> woundFlags;
  final String scaleLength;
  final String tuning;
  final String savedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'instrument': instrument,
      'stringCount': stringCount,
      'gauges': gauges,
      'woundFlags': woundFlags,
      'scaleLength': scaleLength,
      'tuning': tuning,
      'savedAt': savedAt,
    };
  }

  factory SavedSetup.fromJson(Map<String, dynamic> json) {
    return SavedSetup(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? 'Setup',
      instrument: (json['instrument'] as String?) ?? 'guitar',
      stringCount: (json['stringCount'] as int?) ?? 6,
      gauges: ((json['gauges'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      woundFlags: ((json['woundFlags'] as List?) ?? const [])
          .map((e) => e == true)
          .toList(),
      scaleLength: (json['scaleLength'] as String?) ?? '25.5',
      tuning: (json['tuning'] as String?) ?? 'E',
      savedAt: (json['savedAt'] as String?) ?? '',
    );
  }

  /// GET `/users/librarys/` item shape (`selected_tuning`, `scale_sength`, nested `strings`).
  factory SavedSetup.fromLibraryApi(
    Map<String, dynamic> json,
    String tuningId,
  ) {
    final rawStrings = (json['strings'] as List?) ?? [];
    final strings = rawStrings.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    final gauges = strings.map((m) => m['gauge']?.toString() ?? '').toList();
    final wounds = strings
        .map((m) => (m['type']?.toString().toLowerCase() == 'w'))
        .toList();

    final multi = json['is_multi_scale'] == true;
    final scaleLength = multi
        ? strings.map((m) => m['scale']?.toString().trim() ?? '').join(',')
        : (json['scale_sength'] ?? json['scale_length'] ?? '25.50').toString();

    final idVal = json['id'];
    final id = idVal is int ? idVal : int.tryParse(idVal.toString()) ?? 0;

    final requested = (json['total_strings'] as int?) ?? strings.length;
    final n = gauges.isEmpty
        ? requested
        : (requested < gauges.length ? requested : gauges.length);

    String savedAt = '';
    if (strings.isNotEmpty) {
      savedAt = strings.first['create_at']?.toString() ??
          strings.first['update_at']?.toString() ??
          '';
    }

    return SavedSetup(
      id: id,
      name: json['setup_name']?.toString() ?? 'Setup',
      instrument: json['instrument_type']?.toString() ?? 'guitar',
      stringCount: n,
      gauges: gauges.take(n).toList(),
      woundFlags: wounds.take(n).toList(),
      scaleLength: scaleLength,
      tuning: tuningId,
      savedAt: savedAt,
    );
  }
}

class ComputedSetup {
  const ComputedSetup({
    required this.instrument,
    required this.stringCount,
    required this.tuning,
    required this.gauges,
    required this.wounds,
    required this.tensions,
    required this.scales,
    required this.stringNames,
  });

  final String instrument;
  final int stringCount;
  final String tuning;
  final List<String> gauges;
  final List<bool> wounds;
  final List<double> tensions;
  final List<double> scales;
  final List<String> stringNames;
}
