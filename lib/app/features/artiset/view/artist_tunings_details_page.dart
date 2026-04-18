import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistTuningsDetailsPage extends StatefulWidget {
  const ArtistTuningsDetailsPage({super.key});

  @override
  State<ArtistTuningsDetailsPage> createState() => _ArtistTuningsDetailsPageState();
}

class _ArtistTuningsDetailsPageState extends State<ArtistTuningsDetailsPage> {
  final c = Get.find<TuningWorkbenchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: c.selectedArtist?.name ?? 'Artist Setup'),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final artist = c.selectedArtist;
          if (artist == null) {
            return const Center(
              child: Text('No artist selected', style: TextStyle(color: Colors.white70)),
            );
          }

          final isEdited = c.artistHasEditedSetup;
          final instrument = isEdited
              ? (c.artistEditedInstrument == 'bass' ? 'bass' : 'guitar')
              : (artist.instrument == 'bass' ? 'bass' : 'guitar');
          final tuning = isEdited ? c.artistEditedTuning! : artist.tuning;
          final gauges = isEdited
              ? c.artistEditedGauges!
              : artist.gauges.map((g) => g.replaceAll(RegExp(r'[wp]$'), '')).toList();
          final wounds = isEdited
              ? c.artistEditedWounds!
              : artist.gauges.map((g) => g.endsWith('w')).toList();
          final scales = isEdited
              ? c.artistEditedScales!
              : List<double>.filled(gauges.length, artist.scaleLength);
          final tensions = isEdited ? c.artistEditedTensions! : c.computeArtistTensions(artist);
          final names = c.getStringNames(instrument, gauges.length, tuning);
          final total = tensions.fold<double>(0, (a, b) => a + b);
          final gaugeWithSuffix = List.generate(
            gauges.length,
            (i) => gauges[i] + (wounds[i] ? 'w' : ''),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gauge Set & Tension',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTableHeader(),
                const SizedBox(height: 8),
                ...List.generate(gauges.length, (i) {
                  return _buildStringRow(
                    name: names[i],
                    type: wounds[i] ? 'W' : 'P',
                    scale: scales[i],
                    gauge: gauges[i],
                    tension: tensions[i],
                  );
                }),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Neck Tension: ${total.toStringAsFixed(1)} lbs',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tuning: ${c.resolveTuningLabel(tuning)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Scale: ${scales.first.toStringAsFixed(2)}"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gauges: ${gaugeWithSuffix.first} - ${gaugeWithSuffix.last}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        artist.notes,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                CustomButton(
                  onTap: () {
                    c.prepareShop(
                      gauges: gauges,
                      wounds: wounds,
                      packName: '${artist.name} Setup',
                    );
                    Get.toNamed(AppRoutes.shopSetup);
                  },
                  text: 'Shop This Setup',
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    c.loadArtistSetupIntoCalculator();
                    await Get.toNamed(AppRoutes.calculate);
                    c.syncArtistSetupFromCalculator();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFF6B35)),
                      borderRadius: BorderRadius.circular(53),
                    ),
                    child: const Center(
                      child: Text(
                        'Edit in Calculator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: _headerCell('Strings')),
            Expanded(flex: 3, child: _headerCell('Type')),
            Expanded(flex: 2, child: _headerCell('Scale')),
            Expanded(flex: 2, child: _headerCell('Gauge')),
            Expanded(flex: 2, child: _headerCell('Tension')),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) => Text(
        text,
        style: const TextStyle(
          color: Color(0xFF8B8B9E),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );

  Widget _buildStringRow({
    required String name,
    required String type,
    required double scale,
    required String gauge,
    required double tension,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF15192B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2F45)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              type,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${scale.toStringAsFixed(2)}"',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              gauge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${tension.toStringAsFixed(1)} lbs',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
