import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_switch.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  final c = Get.find<TuningWorkbenchController>();

  bool showTuningDropdown = false;
  bool showStringTypeDropdown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1F),
      appBar: CustomAppbar(title: 'Calculate String Tension'),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final isGuitar = c.calcInstrument == 'guitar';
          final names = c.getStringNames(
            c.calcInstrument,
            c.calcStringCount,
            c.calcTuning,
          );

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
                        onGuitar: () => c.changeCalcInstrument(true),
                        onBass: () => c.changeCalcInstrument(false),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _label('Number of Strings')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: c.calcStringCount.toString(),
                        onDecrement: () =>
                            c.changeCalcStringCount(c.calcStringCount - 1),
                        onIncrement: () =>
                            c.changeCalcStringCount(c.calcStringCount + 1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _label('Scale Length')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: '${c.calcScaleLength.toStringAsFixed(1)}"',
                        onDecrement: () => c.setCalcScale(
                          (c.calcScaleLength - 0.5).clamp(24.0, 36.0),
                        ),
                        onIncrement: () => c.setCalcScale(
                          (c.calcScaleLength + 0.5).clamp(24.0, 36.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSwitch(
                          value: c.calcMultiScale,
                          onChanged: c.setCalcMultiScale,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Multi-Scale Instrument',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _label('String Type'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showStringTypeDropdown = true;
                        showTuningDropdown = false;
                      }),
                      child: _buildDropdown(
                        c.resolveStringTypeLabel(c.stringType),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _label('Current Tuning'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showTuningDropdown = true;
                        showStringTypeDropdown = false;
                      }),
                      child: _buildDropdown(c.resolveTuningLabel(c.calcTuning)),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF15192B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Total Neck Tension: ${c.calcTotalTension.toStringAsFixed(1)} lbs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTableHeader(showScale: c.calcMultiScale),
                    const SizedBox(height: 8),

                    ...List.generate(c.calcStringCount, (i) {
                      final scale = c.calcMultiScale
                          ? c.calcStringScales[i]
                          : c.calcScaleLength;
                      return _buildStringRow(
                        name: names[i],
                        index: i,
                        gauge: c.calcGauges[i],
                        isWound: c.calcWounds[i],
                        tension: c.calcTensions.length > i
                            ? c.calcTensions[i]
                            : 0,
                        showScale: c.calcMultiScale,
                        scale: scale,
                        onScaleUp: () => c.setCalcStringScale(
                          i,
                          (scale + 0.5).clamp(24.0, 36.0),
                        ),
                        onScaleDown: () => c.setCalcStringScale(
                          i,
                          (scale - 0.5).clamp(24.0, 36.0),
                        ),
                        onGaugeUp: () => c.bumpCalcGauge(i, 1),
                        onGaugeDown: () => c.bumpCalcGauge(i, -1),
                        onTypePlain: () => c.toggleCalcWound(i, false),
                        onTypeWound: () => c.toggleCalcWound(i, true),
                      );
                    }),
                    const SizedBox(height: 30),

                    _buildOutlineActionButton(
                      text: 'Save this Setup',
                      color: const Color(0xFFD8B4FE),
                      borderColor: const Color(0xFF9333EA),
                      onTap: () => _onSaveSetupTap(),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      onTap: () {
                        c.prepareShop(
                          gauges: c.calcGauges,
                          wounds: c.calcWounds,
                        );
                        Get.toNamed(AppRoutes.shopSetup);
                      },
                      text: 'Shop This Setup',
                    ),
                  ],
                ),
              ),
              if (showTuningDropdown || showStringTypeDropdown)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      showTuningDropdown = false;
                      showStringTypeDropdown = false;
                    }),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              if (showTuningDropdown)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomSheet(
                    items: c.tuningLabels,
                    onSelect: (item) {
                      c.setCalcTuningByLabel(item);
                      setState(() => showTuningDropdown = false);
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

  Future<void> _onSaveSetupTap() async {
    final result = await c.saveFromCalculator();

    String message;
    switch (result) {
      case SaveSetupResult.saved:
        message = 'Setup saved. You can find it in Library.';
      case SaveSetupResult.duplicate:
        message = 'This setup is already saved.';
      case SaveSetupResult.invalid:
        message = 'Unable to save this setup. Please check inputs.';
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1A1D2E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildOutlineActionButton({
    required String text,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(53),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          _counterBtn(Icons.add, onIncrement, isLeft: false),
        ],
      ),
    );
  }

  Widget _counterBtn(
    IconData icon,
    VoidCallback onTap, {
    required bool isLeft,
  }) {
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
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFF1F5F9),
            size: 22,
          ),
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

  Widget _headerCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF8B8B9E),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStringRow({
    required String name,
    required int index,
    required String gauge,
    required bool isWound,
    required double tension,
    required bool showScale,
    required double scale,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onScaleUp,
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Text(
                    '${scale.toStringAsFixed(1)}"',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: onScaleDown,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onGaugeUp,
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Text(
                  gauge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: onGaugeDown,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  Widget _typeBtn(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color(0xFF9D4EDD) : const Color(0xFFF1F5F9),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet({
    required List<String> items,
    required ValueChanged<String> onSelect,
  }) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: Color(0xFF15192B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
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
              separatorBuilder: (_, _) =>
                  const Divider(color: Color(0xFF2A2F45), height: 1),
              itemBuilder: (_, i) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  items[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
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
