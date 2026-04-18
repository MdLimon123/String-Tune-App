import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_switch.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/features/calculate/controller/calculate_controller.dart';
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
  final calc = Get.find<CalculateController>();
  final wb = Get.find<TuningWorkbenchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1F),
      appBar: CustomAppbar(title: 'Calculate String Tension'),
      body: GetBuilder<CalculateController>(
        builder: (_) {
          final isGuitar = calc.instrument == 'guitar';
          final names = wb.getStringNames(
            calc.instrument,
            calc.stringCount,
            calc.tuning,
          );

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: calc.setupName,
                      hintText: 'Setup Name',
                    ),
                    const SizedBox(height: 24),

                    Center(child: _label('Instrument')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildInstrumentToggle(
                        isGuitar: isGuitar,
                        onGuitar: () => calc.changeInstrument(true),
                        onBass: () => calc.changeInstrument(false),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _label('Number of Strings')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: calc.stringCount.toString(),
                        onDecrement: () =>
                            calc.changeStringCount(calc.stringCount - 1),
                        onIncrement: () =>
                            calc.changeStringCount(calc.stringCount + 1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _label('Scale Length')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: '${calc.scaleLength.toStringAsFixed(1)}"',
                        onDecrement: () => calc.setScaleLength(
                          (calc.scaleLength - 0.5).clamp(24.0, 36.0),
                        ),
                        onIncrement: () => calc.setScaleLength(
                          (calc.scaleLength + 0.5).clamp(24.0, 36.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSwitch(
                          value: calc.multiScale,
                          onChanged: calc.setMultiScale,
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
                      onTap: calc.openStringTypeDropdown,
                      child: _buildDropdown(
                        calc.resolveStringTypeLabel(calc.stringType),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _label('Current Tuning'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: calc.openTuningDropdown,
                      child: _buildDropdown(wb.resolveTuningLabel(calc.tuning)),
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
                        'Total Neck Tension: ${calc.totalTension.toStringAsFixed(1)} lbs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTableHeader(showScale: calc.multiScale),
                    const SizedBox(height: 8),

                    ...List.generate(calc.stringCount, (i) {
                      final scale = calc.multiScale
                          ? calc.perStringScales[i]
                          : calc.scaleLength;
                      return _buildStringRow(
                        name: names[i],
                        index: i,
                        gauge: calc.gauges[i],
                        isWound: calc.wounds[i],
                        tension: calc.tensions.length > i
                            ? calc.tensions[i]
                            : 0,
                        showScale: calc.multiScale,
                        scale: scale,
                        onScaleUp: () => calc.setPerStringScale(
                          i,
                          (scale + 0.5).clamp(24.0, 36.0),
                        ),
                        onScaleDown: () => calc.setPerStringScale(
                          i,
                          (scale - 0.5).clamp(24.0, 36.0),
                        ),
                        onGaugeUp: () => calc.bumpGauge(i, 1),
                        onGaugeDown: () => calc.bumpGauge(i, -1),
                        onTypePlain: () => calc.toggleWound(i, false),
                        onTypeWound: () => calc.toggleWound(i, true),
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
                        wb.prepareShop(
                          gauges: calc.gauges,
                          wounds: calc.wounds,
                        );
                        Get.toNamed(AppRoutes.shopSetup);
                      },
                      text: 'Shop This Setup',
                    ),
                  ],
                ),
              ),

              if (calc.showTuningDropdown || calc.showStringTypeDropdown)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: calc.hideDropdownOverlays,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              if (calc.showTuningDropdown)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomSheet(
                    items: wb.tuningLabels,
                    onSelect: (item) {
                      calc.setTuningByLabel(item);
                      calc.closeTuningDropdown();
                    },
                  ),
                ),
              if (calc.showStringTypeDropdown)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomSheet(
                    items: calc.stringTypeLabels,
                    onSelect: (item) {
                      calc.setStringTypeByLabel(item);
                      calc.closeStringTypeDropdown();
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
