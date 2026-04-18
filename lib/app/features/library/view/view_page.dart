import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/features/tuning/domain/tuning_models.dart';
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

  @override
  void initState() {
    super.initState();
    c.loadSavedSetup(widget.setup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: widget.setup.name),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final names = c.getStringNames(c.calcInstrument, c.calcStringCount, c.calcTuning);
          final total = c.calcTotalTension;

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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instrument: ${c.calcInstrument == 'bass' ? 'Bass' : 'Guitar'} (${c.calcStringCount} String)',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scale Length: ${c.calcScaleLength.toStringAsFixed(1)}"',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tuning: ${c.resolveTuningLabel(c.calcTuning)}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gauges: ${c.calcGauges.first} - ${c.calcGauges.last}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Tension: ${total.toStringAsFixed(1)} lbs',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
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
                ...List.generate(c.calcStringCount, (i) {
                  return _buildStringRow(
                    name: names[i],
                    tension: c.calcTensions[i],
                  );
                }),
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

  Widget _buildStringRow({required String name, required double tension}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF15192B),
        borderRadius: BorderRadius.circular(12),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 4,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF9333EA), Color(0xFF334155)],
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
