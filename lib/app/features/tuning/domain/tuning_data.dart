import 'dart:math' as math;
import 'tuning_models.dart';

double nf(String note) => _noteHz[note] ?? 82.41;

const Map<String, double> _noteHz = {
  'Db2': 34.65,
  'F2': 43.65,
  'F#2': 46.25,
  'Gb2': 46.25,
  'G2': 49.00,
  'Ab2': 51.91,
  'A2': 55.00,
  'Bb2': 58.27,
  'B2': 61.74,
  'C3': 65.41,
  'C#3': 69.30,
  'Db3': 69.30,
  'D3': 73.42,
  'Eb3': 77.78,
  'Db4': 138.59,
  'E3': 82.41,
  'F3': 87.31,
  'F#3': 92.50,
  'Gb3': 92.50,
  'G3': 98.00,
  'Ab3': 103.83,
  'A3': 110.00,
  'Bb3': 116.54,
  'B3': 123.47,
  'C4': 130.81,
  'C#4': 138.59,
  'D4': 146.83,
  'Eb4': 155.56,
  'E4': 164.81,
  'F4': 174.61,
  'F#4': 185.00,
  'Gb4': 185.00,
  'G4': 196.00,
  'Ab4': 207.65,
  'A4': 220.00,
  'Bb4': 233.08,
  'B4': 246.94,
  'C5': 261.63,
  'C#5': 277.18,
  'Db5': 277.18,
  'D5': 293.66,
  'Eb5': 311.13,
  'E5': 329.63,
  'F5': 349.23,
  'F#5': 369.99,
  'Gb5': 369.99,
  'G5': 392.00,
};

const List<TuningDefinition> tuningList = [
  // ── STANDARD ──
  TuningDefinition(id: 'E', label: 'E Standard', group: 'Standard', names6: ['e', 'B', 'G', 'D', 'A', 'E'], notes: [329.63, 246.94, 196.00, 146.83, 110.00, 82.41]),
  TuningDefinition(id: 'Eb', label: 'Eb Standard', group: 'Standard', names6: ['eb', 'Bb', 'G', 'Db', 'Ab', 'Eb'], notes: [311.13, 233.08, 196.00, 138.59, 103.83, 77.78]),
  TuningDefinition(id: 'D', label: 'D Standard', group: 'Standard', names6: ['d', 'A', 'F#', 'C', 'G', 'D'], notes: [293.66, 220.00, 185.00, 130.81, 98.00, 73.42]),
  TuningDefinition(id: 'Db', label: 'C# Standard', group: 'Standard', names6: ['c#', 'Ab', 'F', 'B', 'F#', 'C#'], notes: [277.18, 207.65, 174.61, 123.47, 92.50, 69.30]),
  TuningDefinition(id: 'C', label: 'C Standard', group: 'Standard', names6: ['c', 'G', 'Eb', 'Bb', 'F', 'C'], notes: [261.63, 196.00, 155.56, 116.54, 87.31, 65.41]),
  TuningDefinition(id: 'B', label: 'B Standard', group: 'Standard', names6: ['b', 'F#', 'D', 'A', 'E', 'B'], notes: [246.94, 185.00, 146.83, 110.00, 82.41, 61.74]),
  TuningDefinition(id: 'Bb', label: 'Bb Standard', group: 'Standard', names6: ['bb', 'F', 'Db', 'Ab', 'Eb', 'Bb'], notes: [233.08, 174.61, 138.59, 103.83, 77.78, 58.27]),
  TuningDefinition(id: 'A', label: 'A Standard', group: 'Standard', names6: ['a', 'E', 'C', 'G', 'D', 'A'], notes: [220.00, 164.81, 130.81, 98.00, 73.42, 55.00]),
  TuningDefinition(id: 'Ab', label: 'Ab Standard', group: 'Standard', names6: ['ab', 'Eb', 'B', 'Gb', 'Db', 'Ab'], notes: [207.65, 155.56, 123.47, 92.50, 69.30, 51.91]),
  TuningDefinition(id: 'G', label: 'G Standard', group: 'Standard', names6: ['g', 'D', 'Bb', 'F', 'C', 'G'], notes: [196.00, 146.83, 116.54, 87.31, 65.41, 49.00]),
  TuningDefinition(id: 'F#', label: 'F# Standard', group: 'Standard', names6: ['f#', 'C#', 'A', 'E', 'B', 'F#'], notes: [185.00, 138.59, 110.00, 82.41, 61.74, 46.25]),
  TuningDefinition(id: 'F', label: 'F Standard', group: 'Standard', names6: ['f', 'C', 'Ab', 'Eb', 'Bb', 'F'], notes: [174.61, 130.81, 103.83, 77.78, 58.27, 43.65]),
  // ── DROP ──
  TuningDefinition(id: 'DropD', label: 'Drop D', group: 'Drop', names6: ['e', 'B', 'G', 'D', 'A', 'D'], notes: [329.63, 246.94, 196.00, 146.83, 110.00, 73.42]),
  TuningDefinition(id: 'DropDb', label: 'Drop Eb', group: 'Drop', names6: ['eb', 'Bb', 'Gb', 'Db', 'Ab', 'Db'], notes: [311.13, 233.08, 185.00, 138.59, 103.83, 69.30]),
  TuningDefinition(id: 'DropC', label: 'Drop C', group: 'Drop', names6: ['d', 'A', 'F', 'C', 'G', 'C'], notes: [293.66, 220.00, 174.61, 130.81, 98.00, 65.41]),
  TuningDefinition(id: 'DropC#', label: 'Drop C#', group: 'Drop', names6: ['c#', 'Ab', 'E', 'B', 'F#', 'C#'], notes: [277.18, 207.65, 164.81, 123.47, 92.50, 69.30]),
  TuningDefinition(id: 'DropB', label: 'Drop B', group: 'Drop', names6: ['c#', 'Ab', 'E', 'B', 'F#', 'B'], notes: [277.18, 207.65, 164.81, 123.47, 92.50, 61.74]),
  TuningDefinition(id: 'DropBb', label: 'Drop Bb', group: 'Drop', names6: ['c', 'G', 'Eb', 'Bb', 'F', 'Bb'], notes: [261.63, 196.00, 155.56, 116.54, 87.31, 58.27]),
  TuningDefinition(id: 'DropA', label: 'Drop A', group: 'Drop', names6: ['b', 'F#', 'D', 'A', 'E', 'A'], notes: [246.94, 185.00, 146.83, 110.00, 82.41, 55.00]),
  TuningDefinition(id: 'DropAb', label: 'Drop Ab', group: 'Drop', names6: ['bb', 'F', 'Db', 'Ab', 'Eb', 'Ab'], notes: [233.08, 174.61, 138.59, 103.83, 77.78, 51.91]),
  TuningDefinition(id: 'DropG', label: 'Drop G', group: 'Drop', names6: ['a', 'E', 'C', 'G', 'D', 'G'], notes: [220.00, 164.81, 130.81, 98.00, 73.42, 49.00]),
  TuningDefinition(id: 'DropF#', label: 'Drop F#', group: 'Drop', names6: ['ab', 'Eb', 'B', 'F#', 'C#', 'F#'], notes: [207.65, 155.56, 123.47, 92.50, 69.30, 46.25]),
  TuningDefinition(id: 'DropF', label: 'Drop F', group: 'Drop', names6: ['g', 'D', 'Bb', 'F', 'C', 'F'], notes: [196.00, 146.83, 116.54, 87.31, 65.41, 43.65]),
  // ── OPEN MAJOR ──
  TuningDefinition(id: 'OpenE', label: 'Open E', group: 'Open Major', names6: ['e', 'B', 'Ab', 'E', 'B', 'E'], notes: [329.63, 246.94, 207.65, 164.81, 123.47, 82.41]),
  TuningDefinition(id: 'OpenEb', label: 'Open Eb', group: 'Open Major', names6: ['eb', 'Bb', 'G', 'Eb', 'Bb', 'Eb'], notes: [311.13, 233.08, 196.00, 155.56, 116.54, 77.78]),
  TuningDefinition(id: 'OpenD', label: 'Open D', group: 'Open Major', names6: ['d', 'A', 'F#', 'D', 'A', 'D'], notes: [293.66, 220.00, 185.00, 146.83, 110.00, 73.42]),
  TuningDefinition(id: 'OpenC', label: 'Open C', group: 'Open Major', names6: ['e', 'C', 'G', 'C', 'G', 'C'], notes: [329.63, 261.63, 196.00, 130.81, 98.00, 65.41]),
  TuningDefinition(id: 'OpenBb', label: 'Open Bb', group: 'Open Major', names6: ['bb', 'F', 'D', 'Bb', 'F', 'Bb'], notes: [233.08, 174.61, 146.83, 116.54, 87.31, 58.27]),
  TuningDefinition(id: 'OpenB', label: 'Open B', group: 'Open Major', names6: ['b', 'F#', 'Eb', 'B', 'F#', 'B'], notes: [246.94, 185.00, 155.56, 123.47, 92.50, 61.74]),
  TuningDefinition(id: 'OpenA', label: 'Open A', group: 'Open Major', names6: ['e', 'C#', 'A', 'E', 'A', 'E'], notes: [329.63, 277.18, 220.00, 164.81, 110.00, 82.41]),
  TuningDefinition(id: 'OpenG', label: 'Open G', group: 'Open Major', names6: ['d', 'B', 'G', 'D', 'G', 'D'], notes: [293.66, 246.94, 196.00, 146.83, 98.00, 73.42]),
  TuningDefinition(id: 'OpenF', label: 'Open F', group: 'Open Major', names6: ['c', 'A', 'F', 'C', 'F', 'C'], notes: [261.63, 220.00, 174.61, 130.81, 87.31, 65.41]),
  // ── OPEN MINOR ──
  TuningDefinition(id: 'OpenEm', label: 'Open Em', group: 'Open Minor', names6: ['e', 'B', 'G', 'E', 'B', 'E'], notes: [329.63, 246.94, 196.00, 164.81, 123.47, 82.41]),
  TuningDefinition(id: 'OpenDm', label: 'Open Dm', group: 'Open Minor', names6: ['d', 'A', 'F', 'D', 'A', 'D'], notes: [293.66, 220.00, 174.61, 146.83, 110.00, 73.42]),
  TuningDefinition(id: 'OpenCm', label: 'Open Cm', group: 'Open Minor', names6: ['eb', 'C', 'G', 'C', 'G', 'C'], notes: [311.13, 261.63, 196.00, 130.81, 98.00, 65.41]),
  TuningDefinition(id: 'OpenAm', label: 'Open Am', group: 'Open Minor', names6: ['e', 'C', 'A', 'E', 'A', 'E'], notes: [329.63, 261.63, 220.00, 164.81, 110.00, 82.41]),
  TuningDefinition(id: 'OpenGm', label: 'Open Gm', group: 'Open Minor', names6: ['d', 'Bb', 'G', 'D', 'G', 'D'], notes: [293.66, 233.08, 196.00, 146.83, 98.00, 73.42]),
  TuningDefinition(id: 'OpenFm', label: 'Open Fm', group: 'Open Minor', names6: ['c', 'Ab', 'F', 'C', 'F', 'C'], notes: [261.63, 207.65, 174.61, 130.81, 87.31, 65.41]),
  // ── MODAL / DRONE ──
  TuningDefinition(id: 'DADGAD', label: 'DADGAD', group: 'Modal/Drone', names6: ['D', 'A', 'G', 'D', 'A', 'D'], notes: [293.66, 220.00, 196.00, 146.83, 110.00, 73.42]),
  TuningDefinition(id: 'DADFAD', label: 'DADf#AD', group: 'Modal/Drone', names6: ['D', 'A', 'F#', 'D', 'A', 'D'], notes: [293.66, 220.00, 185.00, 146.83, 110.00, 73.42]),
  TuningDefinition(id: 'CGCGCD', label: 'CGCGCD', group: 'Modal/Drone', names6: ['D', 'C', 'G', 'C', 'G', 'C'], notes: [293.66, 261.63, 196.00, 130.81, 98.00, 65.41]),
  TuningDefinition(id: 'CGDGCD', label: 'CGDGCD', group: 'Modal/Drone', names6: ['D', 'C', 'G', 'D', 'G', 'C'], notes: [293.66, 261.63, 196.00, 146.83, 98.00, 65.41]),
  TuningDefinition(id: 'C6', label: 'C6', group: 'Modal/Drone', names6: ['E', 'C', 'G', 'C', 'A', 'C'], notes: [329.63, 261.63, 196.00, 130.81, 110.00, 65.41]),
];

List<double> getStringFreqs(String instrument, int stringCount, String tuningId) {
  final tuning = tuningList.firstWhere((t) => t.id == tuningId,
      orElse: () => tuningList.first);
  final std = tuningList.firstWhere((t) => t.id == 'E');

  if (instrument == 'bass') {
    final bNF = {
      4: [98.00, 73.42, 55.00, 82.41],
      5: [98.00, 73.42, 55.00, 82.41, 61.74],
      6: [130.81, 98.00, 73.42, 55.00, 82.41, 61.74],
    };
    final currentLowE = tuning.notes.length > 5 ? tuning.notes[5] : 82.41;
    final stdLowE = std.notes[5];
    final semitoneOffset =
        (12 * math.log(currentLowE / stdLowE) / math.ln2).round();
    final st = math.pow(2, 1 / 12);
    return (bNF[stringCount] ?? bNF[4]!)
        .map((f) => f * math.pow(st, semitoneOffset))
        .toList();
  }

  final base6 = tuning.notes;
  if (stringCount == 6) return base6;

  if (stringCount == 7) {
    // Standard 7 is B-E, so we shift base6 and add a low B
    final lowB = tuning.notes[5] * math.pow(2, -5 / 12);
    return [...base6, lowB];
  }
  if (stringCount == 8) {
    final lowB = tuning.notes[5] * math.pow(2, -5 / 12);
    final lowFSharp = lowB * math.pow(2, -5 / 12);
    return [...base6, lowB, lowFSharp];
  }

  return base6;
}

const List<StringTypeDefinition> stringTypes = [
  StringTypeDefinition(id: 'nickel', label: 'Nickel Wound', mult: 1.00),
  StringTypeDefinition(id: 'nps', label: 'Nickel-Plated Steel', mult: 1.04),
  StringTypeDefinition(id: 'steel', label: 'Stainless Steel', mult: 1.08),
  StringTypeDefinition(id: 'halfwound', label: 'Half Wound', mult: 1.06),
  StringTypeDefinition(id: 'flatwound', label: 'Flatwound', mult: 1.20),
];

const List<ArtistTuningEntry> artistTunings = [
  ArtistTuningEntry(
    name: 'Tony Iommi',
    band: 'Black Sabbath',
    era: 'MOR / Vol.4 / SBS / Sabotage',
    tuning: 'Db',
    gauges: ['.009', '.010', '.012', '.020', '.032w', '.042w'],
    scaleLength: 24.75,
    notes:
        'Dropped to C# to reduce tension after losing fingertips. Custom light set.',
    verified: true,
    genre: 'Doom',
  ),
  ArtistTuningEntry(
    name: 'Matt Pike',
    band: 'Sleep / High on Fire',
    era: 'C Standard',
    tuning: 'C',
    gauges: ['.012', '.016', '.020', '.036w', '.046w', '.056w'],
    scaleLength: 25.5,
    notes: '12-56. The tone of Dopesmoker.',
    verified: true,
    genre: 'Sludge',
  ),
  ArtistTuningEntry(
    name: 'Kirk Windstein',
    band: 'Crowbar / Down',
    era: 'B Standard',
    tuning: 'B',
    gauges: ['.013', '.017', '.022w', '.036w', '.046w', '.056w'],
    scaleLength: 24.75,
    notes: '13-56. Crushing low-end.',
    verified: true,
    genre: 'Sludge',
  ),
  ArtistTuningEntry(
    name: 'Jus Oborn',
    band: 'Electric Wizard',
    era: 'Come My Fanatics onward',
    tuning: 'B',
    gauges: ['.012', '.016', '.020', '.034w', '.046w', '.060w'],
    scaleLength: 24.75,
    notes: 'Switched to B Standard from Come My Fanatics onward.',
    verified: true,
    genre: 'Doom',
  ),
  ArtistTuningEntry(
    name: 'Stephen O\'Malley',
    band: 'Sunn O)))',
    era: 'Drop A',
    tuning: 'DropA',
    gauges: ['.017', '.024', '.036w', '.046w', '.056w', '.074w'],
    scaleLength: 25.5,
    notes: 'Massive drone setup with heavy strings.',
    verified: true,
    genre: 'Drone',
  ),
  ArtistTuningEntry(
    name: 'Jon Davis',
    band: 'Conan',
    era: 'Drop F',
    tuning: 'DropF',
    gauges: ['.014', '.018', '.036w', '.052w', '.070w', '.080w'],
    scaleLength: 25.5,
    notes: 'Custom set for Conan\'s prehistoric doom.',
    verified: true,
    genre: 'Doom',
  ),
  ArtistTuningEntry(
    name: 'Jimi Hendrix',
    band: 'The Jimi Hendrix Experience',
    era: 'All eras',
    tuning: 'Eb',
    gauges: ['.010', '.013', '.015', '.026w', '.032w', '.038w'],
    scaleLength: 25.5,
    notes: 'Custom light set in Eb for bends and vocals.',
    verified: true,
    genre: 'Rock',
  ),
  ArtistTuningEntry(
    name: 'Stevie Ray Vaughan',
    band: 'Double Trouble',
    era: 'All eras',
    tuning: 'Eb',
    gauges: ['.013', '.015', '.019', '.028w', '.038w', '.058w'],
    scaleLength: 25.5,
    notes: 'Heavy custom set in Eb.',
    verified: true,
    genre: 'Blues',
  ),
  ArtistTuningEntry(
    name: 'James Hetfield',
    band: 'Metallica',
    era: 'Black Album onward',
    tuning: 'Eb',
    gauges: ['.011', '.014', '.018', '.028w', '.038w', '.048w'],
    scaleLength: 25.5,
    notes: 'Power Slinky feel in Eb.',
    verified: true,
    genre: 'Metal',
  ),
  ArtistTuningEntry(
    name: 'Adam Jones',
    band: 'Tool',
    era: 'All eras',
    tuning: 'DropD',
    gauges: ['.010', '.013', '.017', '.030w', '.042w', '.052w'],
    scaleLength: 24.75,
    notes: 'Skinny Top Heavy Bottom in Drop D.',
    verified: true,
    genre: 'Metal',
  ),
  ArtistTuningEntry(
    name: 'Al Cisneros',
    band: 'Sleep / Om',
    era: 'Dopesmoker era onward',
    tuning: 'C',
    gauges: ['.045w', '.065w', '.080w', '.100w'],
    scaleLength: 33.25,
    notes: 'C standard on bass.',
    verified: true,
    genre: 'Doom',
    instrument: 'bass',
  ),
  ArtistTuningEntry(
    name: 'Geezer Butler',
    band: 'Black Sabbath',
    era: 'Master of Reality - The End',
    tuning: 'Db',
    gauges: ['.050w', '.070w', '.095w', '.115w'],
    scaleLength: 34.0,
    notes: 'C# / C tuning through most of career.',
    verified: true,
    genre: 'Doom',
    instrument: 'bass',
  ),
];

const List<StringPack> stringPacks = [
  StringPack(
    id: 'da-nyxl-1046',
    brand: "D'Addario",
    line: 'NYXL',
    name: 'NYXL 10-46',
    type: 'electric',
    gauges: ['.010', '.013', '.017', '.026w', '.036w', '.046w'],
    barcode: '019954191689',
  ),
  StringPack(
    id: 'da-nyxl-1052',
    brand: "D'Addario",
    line: 'NYXL',
    name: 'NYXL 10-52',
    type: 'electric',
    gauges: ['.010', '.013', '.017', '.030w', '.042w', '.052w'],
    barcode: '019954191696',
  ),
  StringPack(
    id: 'eb-2222',
    brand: 'Ernie Ball',
    line: 'Regular Slinky',
    name: 'Regular Slinky 10-46',
    type: 'electric',
    gauges: ['.010', '.013', '.017', '.026w', '.036w', '.046w'],
    barcode: '749699002221',
  ),
  StringPack(
    id: 'eb-2215',
    brand: 'Ernie Ball',
    line: 'Skinny/Heavy',
    name: 'Skinny Top Heavy Bottom 10-52',
    type: 'electric',
    gauges: ['.010', '.013', '.017', '.030w', '.042w', '.052w'],
    barcode: '749699002153',
  ),
  StringPack(
    id: 'eb-2627',
    brand: 'Ernie Ball',
    line: 'Not Even Slinky',
    name: 'Not Even Slinky 12-56',
    type: 'electric',
    gauges: ['.012', '.016', '.024w', '.032w', '.044w', '.056w'],
    barcode: '749699002627',
  ),
  StringPack(
    id: 'el-12052',
    brand: 'Elixir',
    line: 'Nanoweb',
    name: 'Nanoweb 10-46',
    type: 'electric',
    gauges: ['.010', '.013', '.017', '.026w', '.036w', '.046w'],
    barcode: '706290120525',
  ),
  StringPack(
    id: 'da-b-xl170',
    brand: "D'Addario",
    line: 'XL Nickel',
    name: 'XL Bass 45-100',
    type: 'bass',
    gauges: ['.045w', '.065w', '.080w', '.100w'],
    barcode: '019954221706',
  ),
  StringPack(
    id: 'eb-b-2831',
    brand: 'Ernie Ball',
    line: 'Regular Slinky Bass',
    name: 'Regular Slinky Bass 50-105',
    type: 'bass',
    gauges: ['.050w', '.070w', '.085w', '.105w'],
    barcode: '749699028314',
  ),
];

const List<double> guitarScales = [
  24.0,
  24.625,
  24.75,
  25.0,
  25.5,
  26.0,
  26.5,
  27.0,
  27.5,
  28.0,
  28.5,
  29.0,
  29.5,
  30.0,
  30.5,
  31.0,
  31.5,
  32.0,
];

const List<double> bassScales = [30.0, 30.5, 32.0, 33.0, 34.0, 35.0, 36.0];

const Map<int, List<String>> guitarStringNames = {
  6: ['e', 'B', 'G', 'D', 'A', 'E'],
  7: ['e', 'B', 'G', 'D', 'A', 'E', 'B'],
  8: ['e', 'B', 'G', 'D', 'A', 'E', 'B', 'F#'],
};

const Map<int, List<String>> bassStringNames = {
  4: ['G', 'D', 'A', 'E'],
  5: ['G', 'D', 'A', 'E', 'B'],
  6: ['C', 'G', 'D', 'A', 'E', 'B'],
};

const Map<int, List<bool>> defaultWoundGuitar = {
  6: [false, false, false, true, true, true],
  7: [false, false, false, true, true, true, true],
  8: [false, false, false, true, true, true, true, true],
};

const Map<int, List<bool>> defaultWoundBass = {
  4: [false, true, true, true],
  5: [false, true, true, true, true],
  6: [false, false, true, true, true, true],
};

const Map<int, List<String>> defaultGuitarGauges = {
  6: ['.010', '.013', '.017', '.026', '.036', '.046'],
  7: ['.010', '.013', '.017', '.026', '.036', '.046', '.060'],
  8: ['.009', '.011', '.015', '.020', '.030', '.042', '.054', '.070'],
};

const Map<int, List<String>> defaultBassGauges = {
  4: ['.045', '.065', '.085', '.105'],
  5: ['.045', '.065', '.085', '.105', '.130'],
  6: ['.032', '.045', '.065', '.085', '.105', '.130'],
};

const List<String> plainSteps = [
  '.007',
  '.008',
  '.0085',
  '.009',
  '.0095',
  '.010',
  '.011',
  '.012',
  '.013',
  '.014',
  '.015',
  '.016',
  '.017',
  '.018',
  '.019',
  '.020',
];

const List<String> woundSteps = [
  '.017',
  '.018',
  '.019',
  '.020',
  '.021',
  '.022',
  '.024',
  '.026',
  '.028',
  '.030',
  '.032',
  '.034',
  '.036',
  '.038',
  '.040',
  '.042',
  '.044',
  '.046',
  '.048',
  '.050',
  '.052',
  '.054',
  '.056',
  '.058',
  '.060',
  '.062',
  '.064',
  '.066',
  '.068',
  '.070',
  '.072',
  '.074',
  '.080',
  '.085',
  '.090',
  '.095',
  '.100',
  '.105',
  '.110',
];
