import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/features/calculate/controller/calculate_controller.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendedSetupPage extends StatefulWidget {
  const RecommendedSetupPage({super.key});

  @override
  State<RecommendedSetupPage> createState() => _RecommendedSetupPageState();
}

class _RecommendedSetupPageState extends State<RecommendedSetupPage> {
  final c = Get.find<TuningWorkbenchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: 'Recommended Setup'),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final result = c.buildResult;
          if (result == null) {
            return const Center(
              child: Text(
                'No generated setup found.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final total = result.tensions.fold<double>(0, (a, b) => a + b);
          final gaugeRange = '${result.gauges.first} - ${result.gauges.last}';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Optimized for ${c.resolveTuningLabel(result.tuning)} at ${result.scales.first.toStringAsFixed(1)}"',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recommended Gauge Set & Tension',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                _buildTableHeader(showScale: c.buildMultiScale),
                const SizedBox(height: 8),
                ...List.generate(result.gauges.length, (i) {
                  return _buildStringRow(
                    name: result.stringNames[i],
                    gauge: result.gauges[i],
                    isWound: result.wounds[i],
                    tension: result.tensions[i],
                    scale: result.scales[i],
                    showScale: c.buildMultiScale,
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
                        'String Type: ${c.resolveStringTypeLabel(c.stringType)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tension Feel: ${_feelLabel(c.buildFeelId)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gauges: $gaugeRange',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                CustomButton(
                  onTap: _onSaveSetupTap,
                  text: 'Save',
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    c.prepareShop(gauges: result.gauges, wounds: result.wounds);
                    Get.toNamed(AppRoutes.shopSetup);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF9333EA)),
                      borderRadius: BorderRadius.circular(53),
                    ),
                    child: const Center(
                      child: Text(
                        'Shop This Setup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD8B4FE),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    c.loadBuildResultIntoCalculator();
                    await Get.toNamed(AppRoutes.calculate);
                    c.syncBuildResultFromCalculator();
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

  Future<void> _onSaveSetupTap() async {
    c.loadBuildResultIntoCalculator();
    final calc = Get.find<CalculateController>();
    final result = await calc.saveSetupToServerAndLibrary();

    late final String message;
    late final Color snackBg;
    late final Color snackFg;
    switch (result) {
      case CalculateSaveResult.saved:
        message = 'Setup saved successfully.';
        snackBg = const Color(0xFFD1FAE5);
        snackFg = const Color(0xFF065F46);
      case CalculateSaveResult.duplicate:
        message = 'This setup is already saved.';
        snackBg = const Color(0xFFEDE9FE);
        snackFg = const Color(0xFF5B21B6);
      case CalculateSaveResult.invalid:
        message = 'Unable to save this setup. Please check inputs.';
        snackBg = const Color(0xFFFEF3C7);
        snackFg = const Color(0xFF92400E);
      case CalculateSaveResult.networkError:
        message = calc.lastSaveErrorMessage.isNotEmpty
            ? calc.lastSaveErrorMessage
            : 'Could not reach the server. Check your connection and try again.';
        snackBg = const Color(0xFFFFE4E6);
        snackFg = AppColors.error;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: snackFg,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: snackBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        elevation: 4,
      ),
    );
  }

  String _feelLabel(String? id) {
    switch (id) {
      case 'loose':
        return 'Loose & Sludgy';
      case 'balanced':
        return 'Balanced';
      case 'tight':
        return 'Tight & Precise';
      default:
        return 'Balanced';
    }
  }

  Widget _buildTableHeader({required bool showScale}) {
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
            if (showScale) Expanded(flex: 2, child: _headerCell('Scale')),
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
    required String gauge,
    required bool isWound,
    required double tension,
    required double scale,
    required bool showScale,
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
              isWound ? 'W' : 'P',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (showScale)
            Expanded(
              flex: 2,
              child: Text(
                '${scale.toStringAsFixed(1)}"',
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
