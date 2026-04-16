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
