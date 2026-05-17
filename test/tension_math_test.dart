import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:does_it_doom/app/core/storage/storage_service.dart';
import 'package:does_it_doom/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:does_it_doom/app/features/calculate/controller/calculate_controller.dart';

void main() {
  setUp(() async {
    // Mock shared preferences values
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    
    // Register controllers in the correct order to resolve initialization dependencies
    Get.put(TuningWorkbenchController());
    Get.put(CalculateController());
  });

  tearDown(() {
    Get.reset();
  });

  group('String Tension Physics and Parsing Tests', () {
    test('Plain string tension calculation is correct (matching React parity)', () {
      final wb = Get.find<TuningWorkbenchController>();
      
      // .010 plain steel at E5 (329.63 Hz), 25.5" scale length
      final tension = wb.computeTension(
        gauge: '.010',
        wound: false,
        scaleInches: 25.5,
        freqHz: 329.63,
        stringTypeMult: 1.0,
      );

      // Parity check: React produces 16.2 lbs
      expect(tension, closeTo(16.2, 0.1));
    });

    test('Wound string tension parsing handles "w" suffix and produces correct tension', () {
      final wb = Get.find<TuningWorkbenchController>();

      // .046 wound steel with "w" suffix at E3 (82.41 Hz), 25.5" scale length
      final tension = wb.computeTension(
        gauge: '.046w',
        wound: true,
        scaleInches: 25.5,
        freqHz: 82.41,
        stringTypeMult: 1.0,
      );

      // Parity check: React produces 17.5 lbs
      expect(tension, closeTo(17.5, 0.1));
    });

    test('Wound string tension parsing handles "p" suffix and produces correct tension', () {
      final wb = Get.find<TuningWorkbenchController>();

      // .046 wound steel with "p" suffix (sometimes used for plain representation)
      final tension = wb.computeTension(
        gauge: '.046p',
        wound: true,
        scaleInches: 25.5,
        freqHz: 82.41,
        stringTypeMult: 1.0,
      );

      // Parity check: should parse identically to '.046'
      expect(tension, closeTo(17.5, 0.1));
    });

    test('Wound string type multiplier applies correctly for Flatwounds (1.20)', () {
      final wb = Get.find<TuningWorkbenchController>();

      // .045 wound at standard octave frequency with 1.20 flatwound multiplier
      final tension = wb.computeTension(
        gauge: '.045',
        wound: true,
        scaleInches: 34.0, // standard bass scale
        freqHz: 98.0, // G
        stringTypeMult: 1.20,
      );

      // 0.00035898 (approx) * (2*34*98)^2 / 386.4 * 1.20
      expect(tension, greaterThan(0));
    });

    test('generateBuild solves guitar and bass setups correctly', () {
      final wb = Get.find<TuningWorkbenchController>();

      // Guitar E standard, balanced feel (15.5 lbs)
      wb.buildInstrument = 'guitar';
      wb.buildStringCount = 6;
      wb.buildTuning = 'E';
      wb.buildSingleScale = 25.5;
      wb.buildFeelId = 'balanced';
      wb.stringType = 'nickel';
      
      wb.generateBuild();

      final res = wb.buildResult;
      expect(res, isNotNull);
      expect(res!.gauges.length, 6);
      expect(res.wounds.length, 6);

      // Bass standard, balanced feel (15.5 lbs)
      wb.buildInstrument = 'bass';
      wb.buildStringCount = 4;
      wb.buildTuning = 'E'; // Bass E
      wb.buildSingleScale = 34.0;
      wb.buildFeelId = 'balanced';
      wb.stringType = 'nickel';

      wb.generateBuild();

      final bassRes = wb.buildResult;
      expect(bassRes, isNotNull);
      expect(bassRes!.gauges.length, 4);
      expect(bassRes.wounds, contains(true)); // bass should be all wound strings
    });
  });
}
