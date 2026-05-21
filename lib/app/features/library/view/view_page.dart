import 'package:does_it_doom/app/core/utils/custom_appbar.dart';
import 'package:does_it_doom/app/core/utils/custom_button.dart';
import 'package:does_it_doom/app/features/calculate/controller/calculate_controller.dart';
import 'package:does_it_doom/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:does_it_doom/app/features/tuning/domain/tuning_models.dart';
import 'package:does_it_doom/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key, required this.setup});

  final SavedSetup setup;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  final c = Get.find<TuningWorkbenchController>();
  final calc = Get.find<CalculateController>();

  @override
  void initState() {
    super.initState();
    c.loadSavedSetup(widget.setup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: widget.setup.name),
      body: GetBuilder<CalculateController>(
        builder: (_) {
          final names = c.getStringNames(
            calc.instrument,
            calc.stringCount,
            calc.tuning,
          );
          final total = calc.totalTension;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR CURRENT SETUP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instrument: ${calc.instrument == 'bass' ? 'Bass' : 'Guitar'} (${calc.stringCount} String)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scale Length: ${c.formatScale(calc.scaleLength)}"',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tuning: ${c.resolveTuningLabel(calc.tuning)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gauges: ${calc.gauges.first} - ${calc.gauges.last}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Tension: ${total.round()} lbs  ·  Avg: ${(calc.gauges.isNotEmpty ? total / calc.gauges.length : 0.0).toStringAsFixed(1)} lbs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'STRING TENSION BREAKDOWN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                _buildTableHeader(),
                const SizedBox(height: 8),
                ...List.generate(calc.stringCount, (i) {
                  final g = i < calc.gauges.length ? calc.gauges[i] : '';
                  final w = i < calc.wounds.length ? calc.wounds[i] : false;
                  return _buildStringRow(
                    name: names[i],
                    type: w ? 'W' : 'P',
                    gauge: g,
                    tension: calc.tensions[i],
                  );
                }),
                const SizedBox(height: 32),
                CustomButton(
                  onTap: () {
                    c.prepareShop(gauges: calc.gauges, wounds: calc.wounds);
                    Get.toNamed(AppRoutes.shopSetup);
                  },
                  text: 'Shop This Setup',
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    await Get.toNamed(AppRoutes.calculate);
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D2E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      '${tension.toStringAsFixed(1)} lbs',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (tension / 25.0).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: tension < 12.0
                                ? [const Color(0xFFFF6B35), const Color(0xFFFF8C61)]
                                : tension < 15.0
                                    ? [const Color(0xFFFFD700), const Color(0xFFFFE066)]
                                    : [const Color(0xFF4ADE80), const Color(0xFF86EFAC)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
