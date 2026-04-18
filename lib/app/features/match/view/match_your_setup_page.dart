import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_switch.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/routes/app_routes.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1F),
      appBar: CustomAppbar(title: 'Match Your Setup'),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final isGuitar = c.srcInstrument == 'guitar';
          final names = c.getStringNames(c.srcInstrument, c.srcStringCount, c.srcTuning);
          final matchedCount = c.tgtGauges.isNotEmpty ? c.tgtGauges.length : c.srcStringCount;
          final matchedNames = c.getStringNames(c.srcInstrument, matchedCount, c.tgtTuning);

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

                    Center(child: _label('Scale Length')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: '${c.srcScale.toStringAsFixed(1)}"',
                        onDecrement: () => c.setMatchScale((c.srcScale - 0.5).clamp(24.0, 36.0)),
                        onIncrement: () => c.setMatchScale((c.srcScale + 0.5).clamp(24.0, 36.0)),
                      ),
                    ),
                    const SizedBox(height: 20),

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

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF15192B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Source Neck Tension: ${c.srcTensions.fold<double>(0, (a, b) => a + b).toStringAsFixed(1)} lbs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTableHeader(showScale: c.srcMultiScale),
                    const SizedBox(height: 8),
                    ...List.generate(c.srcStringCount, (i) {
                      final scale = c.srcMultiScale ? c.srcScales[i] : c.srcScale;
                      return _buildStringRow(
                        name: names[i],
                        gauge: c.srcGauges[i],
                        isWound: c.srcWounds[i],
                        tension: c.srcTensions[i],
                        scale: scale,
                        showScale: c.srcMultiScale,
                        onScaleUp: () => c.setMatchScaleAt(i, (scale + 0.5).clamp(24.0, 36.0)),
                        onScaleDown: () => c.setMatchScaleAt(i, (scale - 0.5).clamp(24.0, 36.0)),
                        onGaugeUp: () => c.bumpSrcGauge(i, 1),
                        onGaugeDown: () => c.bumpSrcGauge(i, -1),
                        onTypePlain: () => c.toggleSrcWound(i, false),
                        onTypeWound: () => c.toggleSrcWound(i, true),
                      );
                    }),
                    const SizedBox(height: 20),

                    CustomButton(
                      onTap: c.generateMatchFeel,
                      text: 'Match The Feel',
                    ),

                    if (c.matchGenerated && c.tgtGauges.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF15192B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Matched Neck Tension: ${c.tgtTensions.fold<double>(0, (a, b) => a + b).toStringAsFixed(1)} lbs',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
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
                          onScaleUp: () => c.setTargetScaleAt(i, (scale + 0.5).clamp(24.0, 36.0)),
                          onScaleDown: () => c.setTargetScaleAt(i, (scale - 0.5).clamp(24.0, 36.0)),
                          onGaugeUp: () => c.bumpTgtGauge(i, 1),
                          onGaugeDown: () => c.bumpTgtGauge(i, -1),
                          onTypePlain: () => c.toggleTgtWound(i, false),
                          onTypeWound: () => c.toggleTgtWound(i, true),
                        );
                      }),
                      const SizedBox(height: 20),
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
                          c.syncMatchResultFromCalculator();
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
                  child: _buildBottomSheet(
                    items: c.tuningLabels,
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
                  child: _buildBottomSheet(
                    items: c.tuningLabels,
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
                  Text('${scale.toStringAsFixed(1)}"', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
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
              child: Text(
                '${tension.toStringAsFixed(1)} lbs',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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
}
