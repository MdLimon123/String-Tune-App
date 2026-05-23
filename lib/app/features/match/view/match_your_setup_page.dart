import 'package:does_it_doom/app/core/utils/app_snackbar.dart';
import 'package:does_it_doom/app/core/utils/custom_appbar.dart';
import 'package:does_it_doom/app/core/utils/custom_button.dart';
import 'package:does_it_doom/app/core/utils/custom_switch.dart';
import 'package:does_it_doom/app/features/calculate/controller/calculate_controller.dart';
import 'package:does_it_doom/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:does_it_doom/app/features/tuning/domain/tuning_data.dart';
import 'package:does_it_doom/app/features/tuning/domain/tuning_models.dart';
import 'package:does_it_doom/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchYourSetupPage extends StatefulWidget {
  const MatchYourSetupPage({super.key});

  @override
  State<MatchYourSetupPage> createState() => _MatchYourSetupPageState();
}

class _MatchYourSetupPageState extends State<MatchYourSetupPage> {
  final c = Get.find<TuningWorkbenchController>();

  bool showSrcTuningDropdown = false;
  bool showTargetTuningDropdown = false;
  bool showStringTypeDropdown = false;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final calc = Get.find<CalculateController>();

    String title = 'Match Your Setup';
    if (args is Map && args['title'] != null) {
      title = args['title'].toString();
    } else {
      final fromController = c.matchSourceSetupName.trim();
      final fromCalc = calc.setupName.text.trim();
      if (fromController.isNotEmpty) {
        title = fromController;
      } else if (fromCalc.isNotEmpty) {
        title = fromCalc;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1F),
      appBar: CustomAppbar(title: title),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final isGuitar = c.srcInstrument == 'guitar';
          final matchedCount = c.tgtGauges.isNotEmpty ? c.tgtGauges.length : c.srcStringCount;
          final matchedNames = c.getStringNames(c.srcInstrument, matchedCount, c.tgtTuning);
          final srcNames = c.getStringNames(c.srcInstrument, c.srcStringCount, c.srcTuning);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _label('Instrument')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildInstrumentToggle(
                        isGuitar: isGuitar,
                        onGuitar: () => c.setMatchInstrument(true),
                        onBass: () => c.setMatchInstrument(false),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _label('Number of Strings')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: c.srcStringCount.toString(),
                        onDecrement: () => c.changeMatchStringCount(c.srcStringCount - 1),
                        onIncrement: () => c.changeMatchStringCount(c.srcStringCount + 1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _mixedLabel('Current', ' Scale Length')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: '${c.formatScale(c.srcScale)}"',
                        onDecrement: c.decrementMatchScale,
                        onIncrement: c.incrementMatchScale,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSwitch(value: c.srcMultiScale, onChanged: c.setMatchMultiScale),
                        const SizedBox(width: 10),
                        const Text(
                          'Multi-Scale Instrument',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _label('String Type'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showStringTypeDropdown = true;
                        showSrcTuningDropdown = false;
                        showTargetTuningDropdown = false;
                      }),
                      child: _buildDropdown(c.resolveStringTypeLabel(c.stringType)),
                    ),
                    const SizedBox(height: 24),

                    _label('Current Tuning'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showSrcTuningDropdown = true;
                        showStringTypeDropdown = false;
                        showTargetTuningDropdown = false;
                      }),
                      child: _buildDropdown(c.resolveTuningLabel(c.srcTuning)),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF15192B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Total Neck Tension: ${c.srcTensions.fold<double>(0, (a, b) => a + b).toStringAsFixed(1)} lbs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildTableHeader(showScale: c.srcMultiScale),
                    const SizedBox(height: 8),
                    ...List.generate(c.srcStringCount, (i) {
                      final scale = c.srcMultiScale ? c.srcScales[i] : c.srcScale;
                      return _buildStringRow(
                        name: srcNames[i],
                        gauge: c.srcGauges[i],
                        isWound: c.srcWounds[i],
                        tension: c.srcTensions[i],
                        scale: scale,
                        showScale: c.srcMultiScale,
                        onScaleUp: () => c.incrementMatchScaleAt(i),
                        onScaleDown: () => c.decrementMatchScaleAt(i),
                        onGaugeUp: () => c.bumpSrcGauge(i, 1),
                        onGaugeDown: () => c.bumpSrcGauge(i, -1),
                        onTypePlain: () => c.toggleSrcWound(i, false),
                        onTypeWound: () => c.toggleSrcWound(i, true),
                      );
                    }),
                    const SizedBox(height: 32),

                    const Text(
                      'Target Tuning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _label('Target Tuning'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showTargetTuningDropdown = true;
                        showStringTypeDropdown = false;
                        showSrcTuningDropdown = false;
                      }),
                      child: _buildDropdown(c.resolveTuningLabel(c.tgtTuning)),
                    ),
                    const SizedBox(height: 24),

                    _label('String Type'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showStringTypeDropdown = true;
                        showSrcTuningDropdown = false;
                        showTargetTuningDropdown = false;
                      }),
                      child: _buildDropdown(c.resolveStringTypeLabel(c.stringType)),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _mixedLabel('Target', ' Scale Length')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: '${c.formatScale(c.tgtScale)}"',
                        onDecrement: c.decrementTargetScale,
                        onIncrement: c.incrementTargetScale,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSwitch(value: c.tgtMultiScale, onChanged: c.setTargetMultiScale),
                        const SizedBox(width: 10),
                        const Text(
                          'Multi-Scale Instrument',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    CustomButton(
                      onTap: () {
                        c.generateMatchFeel();
                        setState(() {});
                      },
                      text: 'Match My Feel',
                    ),
                    const SizedBox(height: 30),

                    if (c.matchGenerated) ...[
                      const Text(
                        'Matched Gauges',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${c.resolveTuningLabel(c.tgtTuning)} Std · ${c.tgtMultiScale ? "multi-scale" : "${c.tgtScale}\""} · matched to ${c.resolveTuningLabel(c.srcTuning)} Std · ${c.srcMultiScale ? "multi-scale" : "${c.srcScale}\""}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF15192B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Matched Neck Tension: ${c.tgtTensions.fold<double>(0, (a, b) => a + b).round()} lbs  ·  Avg: ${(c.srcStringCount > 0 ? c.tgtTensions.fold<double>(0, (a, b) => a + b) / c.srcStringCount : 0.0).toStringAsFixed(1)} lbs',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tension Comparison Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'TENSION COMPARISON',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'SOURCE',
                                      style: TextStyle(color: Color(0xFF4ADE80), fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${(c.srcTensions.fold<double>(0, (a, b) => a + b) / c.srcStringCount).toStringAsFixed(1)} avg lbs',
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${c.resolveTuningLabel(c.srcTuning)} - ${c.formatScale(c.srcScale)}"',
                                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'MATCHED',
                                      style: TextStyle(color: Color(0xFF9333EA), fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${(c.tgtTensions.fold<double>(0, (a, b) => a + b) / c.srcStringCount).toStringAsFixed(1)} avg lbs',
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${c.resolveTuningLabel(c.tgtTuning)} - ${c.formatScale(c.tgtScale)}"',
                                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTableHeader(showScale: c.tgtMultiScale),
                      const SizedBox(height: 8),
                      ...List.generate(matchedCount, (i) {
                        final scale = c.tgtMultiScale ? c.tgtScales[i] : c.tgtScale;
                        return _buildStringRow(
                          name: matchedNames[i],
                          gauge: c.tgtGauges[i],
                          isWound: c.tgtWounds[i],
                          tension: c.tgtTensions[i],
                          scale: scale,
                          showScale: c.tgtMultiScale,
                          onScaleUp: () => c.incrementTargetScaleAt(i),
                          onScaleDown: () => c.decrementTargetScaleAt(i),
                          onGaugeUp: () => c.bumpTgtGauge(i, 1),
                          onGaugeDown: () => c.bumpTgtGauge(i, -1),
                          onTypePlain: () => c.toggleTgtWound(i, false),
                          onTypeWound: () => c.toggleTgtWound(i, true),
                        );
                      }),
                      const SizedBox(height: 20),
                      CustomButton(
                        onTap: () async {
                          final res = await c.saveFromMatch();
                          if (res == SaveSetupResult.saved) {
                            AppSnackbar.success('Matched setup saved to library!');
                          } else if (res == SaveSetupResult.duplicate) {
                            AppSnackbar.error('This setup already exists in your library.');
                          } else {
                            AppSnackbar.error('Failed to save setup.');
                          }
                        },
                        text: 'Save Matched Setup',
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        onTap: () {
                          c.prepareShop(gauges: c.tgtGauges, wounds: c.tgtWounds);
                          Get.toNamed(AppRoutes.shopSetup);
                        },
                        text: 'Shop This Setup',
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          c.loadMatchResultIntoCalculator();
                          await Get.toNamed(AppRoutes.calculate);
                          c.syncMatchSrcFromCalculator();
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
                  ],
                ),
              ),
              if (showSrcTuningDropdown || showTargetTuningDropdown || showStringTypeDropdown)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      showSrcTuningDropdown = false;
                      showTargetTuningDropdown = false;
                      showStringTypeDropdown = false;
                    }),
                    child: Container(color: Colors.black.withValues(alpha: 0.3)),
                  ),
                ),
              if (showSrcTuningDropdown)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildTuningBottomSheet(
                    onSelect: (item) {
                      c.setMatchTuningByLabel(item);
                      setState(() => showSrcTuningDropdown = false);
                    },
                  ),
                ),
              if (showTargetTuningDropdown)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildTuningBottomSheet(
                    onSelect: (item) {
                      c.setTargetTuningByLabel(item);
                      setState(() => showTargetTuningDropdown = false);
                    },
                  ),
                ),
              if (showStringTypeDropdown)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomSheet(
                    items: c.stringTypeLabels,
                    onSelect: (item) {
                      c.setStringTypeByLabel(item);
                      setState(() => showStringTypeDropdown = false);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );

  Widget _mixedLabel(String boldPart, String normalPart) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: boldPart,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: normalPart,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );

  Widget _buildInstrumentToggle({
    required bool isGuitar,
    required VoidCallback onGuitar,
    required VoidCallback onBass,
  }) {
    return Container(
      width: 154,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2235),
        borderRadius: BorderRadius.circular(58),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleItem('Guitar', isGuitar, onGuitar)),
          Expanded(child: _toggleItem('Bass', !isGuitar, onBass)),
        ],
      ),
    );
  }

  Widget _toggleItem(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9333EA) : Colors.transparent,
          borderRadius: BorderRadius.circular(62),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF8A8FA8),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounter({
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      height: 44,
      width: 186,
      decoration: BoxDecoration(
        color: const Color(0xFF15192B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF7C5CBF), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _counterBtn(Icons.remove, onDecrement, isLeft: true),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          _counterBtn(Icons.add, onIncrement, isLeft: false),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap, {required bool isLeft}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F45),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isLeft ? 22 : 0),
            bottomLeft: Radius.circular(isLeft ? 22 : 0),
            topRight: Radius.circular(isLeft ? 0 : 22),
            bottomRight: Radius.circular(isLeft ? 0 : 22),
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF94A3B8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFF1F5F9), size: 22),
        ],
      ),
    );
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
    required VoidCallback onScaleUp,
    required VoidCallback onScaleDown,
    required VoidCallback onGaugeUp,
    required VoidCallback onGaugeDown,
    required VoidCallback onTypePlain,
    required VoidCallback onTypeWound,
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
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _typeBtn('P', !isWound, onTypePlain),
                const SizedBox(width: 6),
                _typeBtn('W', isWound, onTypeWound),
              ],
            ),
          ),
          if (showScale)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  GestureDetector(onTap: onScaleUp, child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 18)),
                  Text('${c.formatScale(scale)}"', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                  GestureDetector(onTap: onScaleDown, child: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18)),
                ],
              ),
            ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                GestureDetector(onTap: onGaugeUp, child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 18)),
                Text(gauge, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                GestureDetector(onTap: onGaugeDown, child: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18)),
              ],
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
                  Text(
                    '${tension.toStringAsFixed(1)} lbs',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
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

  Widget _typeBtn(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: selected ? const Color(0xFF9D4EDD) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet({required List<String> items, required ValueChanged<String> onSelect}) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: Color(0xFF15192B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2F45),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(color: Color(0xFF2A2F45), height: 1),
              itemBuilder: (_, i) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  items[i],
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                onTap: () => onSelect(items[i]),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTuningBottomSheet({
    required ValueChanged<String> onSelect,
  }) {
    final Map<String, List<TuningDefinition>> grouped = {};
    for (final tuning in tuningList) {
      grouped.putIfAbsent(tuning.group, () => []).add(tuning);
    }

    final groupsOrder = ['Standard', 'Drop', 'Open Major', 'Open Minor', 'Modal/Drone'];

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF15192B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 25,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Select Tuning',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: groupsOrder.length,
              itemBuilder: (context, groupIdx) {
                final groupName = groupsOrder[groupIdx];
                final tunings = grouped[groupName] ?? [];
                if (tunings.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (groupName != 'Standard') ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          groupName,
                          style: const TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tunings.length,
                      itemBuilder: (context, idx) {
                        final tuning = tunings[idx];
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                tuning.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () => onSelect(tuning.label),
                            ),
                            if (idx < tunings.length - 1)
                              const Divider(
                                color: Color(0xFF2A2F45),
                                height: 1,
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
