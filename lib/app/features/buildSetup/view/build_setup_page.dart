import 'package:does_it_doom/app/core/utils/custom_appbar.dart';
import 'package:does_it_doom/app/core/utils/custom_button.dart';
import 'package:does_it_doom/app/core/utils/custom_switch.dart';
import 'package:does_it_doom/app/core/utils/custom_text_field.dart';
import 'package:does_it_doom/app/features/buildSetup/view/recommended_setup_page.dart';
import 'package:does_it_doom/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:does_it_doom/app/features/tuning/domain/tuning_data.dart';
import 'package:does_it_doom/app/features/tuning/domain/tuning_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildSetupPage extends StatefulWidget {
  const BuildSetupPage({super.key});

  @override
  State<BuildSetupPage> createState() => _BuildSetupPageState();
}

class _BuildSetupPageState extends State<BuildSetupPage> {
  final c = Get.find<TuningWorkbenchController>();

  bool showTuningDropdown = false;
  bool showStringTypeDropdown = false;
  int? activeScaleStringIndex;

  final List<Map<String, String>> _options = const [
    {'value': 'loose', 'label': 'Loose & Sludgy'},
    {'value': 'balanced', 'label': 'Balanced'},
    {'value': 'tight', 'label': 'Tight & Precise'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Build Setup'),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final isGuitar = c.buildInstrument == 'guitar';

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CustomTextField(
                      controller: c.setupName,
                      hintText: 'Setup Name',
                      onChanged: (value) => c.setSetupName(value),
                    ),

                    Center(child: _label('Instrument')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildInstrumentToggle(
                        isGuitar: isGuitar,
                        onGuitar: () => c.setBuildInstrument(true),
                        onBass: () => c.setBuildInstrument(false),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(child: _label('Number of Strings')),
                    const SizedBox(height: 10),
                    Center(
                      child: _buildCounter(
                        value: c.buildStringCount.toString(),
                        onDecrement: () => c.setBuildStringCount(c.buildStringCount - 1),
                        onIncrement: () => c.setBuildStringCount(c.buildStringCount + 1),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (!c.buildMultiScale) ...[
                      Center(child: _label('Scale Length')),
                      const SizedBox(height: 10),
                      Center(
                        child: _buildCounter(
                          value: '${c.formatScale(c.buildSingleScale)}"',
                          onDecrement: c.decrementBuildSingleScale,
                          onIncrement: c.incrementBuildSingleScale,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSwitch(
                          value: c.buildMultiScale,
                          onChanged: c.setBuildMultiScale,
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
                    const SizedBox(height: 16),

                    if (c.buildMultiScale) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SCALE LENGTH PER STRING',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(c.buildStringCount, (i) {
                              final stringNames = c.getStringNames(
                                c.buildInstrument,
                                c.buildStringCount,
                                c.buildTuning,
                              );
                              final name = stringNames[i];
                              final scale = c.buildScales[i];
                              return _buildMultiScaleStringRow(i, name, scale, c);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      const SizedBox(height: 8),
                    ],

                    _label('String Type'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showStringTypeDropdown = true;
                        showTuningDropdown = false;
                      }),
                      child: _buildDropdown(c.resolveStringTypeLabel(c.stringType)),
                    ),
                    const SizedBox(height: 24),

                    _label('Current Tuning'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => setState(() {
                        showTuningDropdown = true;
                        showStringTypeDropdown = false;
                      }),
                      child: _buildDropdown(c.resolveTuningLabel(c.buildTuning)),
                    ),
                    const SizedBox(height: 24),

                    _label('PLAYING STYLE'),
                    const SizedBox(height: 8),
                    ..._options.map(
                      (opt) => _OptionCard(
                        label: opt['label']!,
                        value: opt['value']!,
                        isSelected: c.buildFeelId == opt['value'],
                        onTap: () => c.setBuildFeel(opt['value']!),
                      ),
                    ),

                    const SizedBox(height: 32),
                    CustomButton(
                      onTap: () {
                        c.generateBuild();
                        if (c.buildResult != null) {
                          Get.to(() => const RecommendedSetupPage());
                        }
                      },
                      text: 'Generate Setup',
                    ),
                  ],
                ),
              ),
              if (showTuningDropdown || showStringTypeDropdown || activeScaleStringIndex != null)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      showTuningDropdown = false;
                      showStringTypeDropdown = false;
                      activeScaleStringIndex = null;
                    }),
                    child: Container(color: Colors.black.withValues(alpha: 0.3)),
                  ),
                ),
              if (showTuningDropdown)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildTuningBottomSheet(
                    onSelect: (item) {
                      c.setBuildTuningByLabel(item);
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
              if (activeScaleStringIndex != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildScaleBottomSheet(
                    index: activeScaleStringIndex!,
                    c: c,
                    onSelect: (scale) {
                      c.setBuildStringScale(activeScaleStringIndex!, scale);
                      setState(() => activeScaleStringIndex = null);
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
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFF1F5F9),
            size: 22,
          ),
        ],
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

  Widget _buildMultiScaleStringRow(int index, String name, double scale, TuningWorkbenchController c) {
    final min = c.buildInstrument == 'bass' ? 30.0 : 24.0;
    final max = c.buildInstrument == 'bass' ? 36.0 : 32.0;
    final fraction = ((scale - min) / (max - min)).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              name,
              style: const TextStyle(
                color: Color(0xFF8A8FA8),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeScaleStringIndex = index;
                  showTuningDropdown = false;
                  showStringTypeDropdown = false;
                });
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: activeScaleStringIndex == index
                        ? Colors.white
                        : const Color(0xFF2A2F45),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${c.formatScale(scale)}"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF8A8FA8),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2235),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleBottomSheet({
    required int index,
    required TuningWorkbenchController c,
    required ValueChanged<double> onSelect,
  }) {
    final isBass = c.buildInstrument == 'bass';
    final scales = isBass
        ? TuningWorkbenchController.availableScales.where((s) => s >= 30.0).toList()
        : TuningWorkbenchController.availableScales.where((s) => s <= 32.0).toList();

    return Container(
      height: 380,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Select Scale Length (String ${index + 1})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: scales.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Color(0xFF2A2F45), height: 1),
              itemBuilder: (context, i) {
                final scale = scales[i];
                final isSelected = c.buildScales[index] == scale;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${c.formatScale(scale)}"',
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF9333EA) : Colors.white,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFF9333EA), size: 20)
                      : null,
                  onTap: () => onSelect(scale),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF9333EA) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF9333EA) : const Color(0xFFF1F5F9),
                border: Border.all(
                  color: isSelected ? const Color(0xFF9333EA) : const Color(0xFF94A3B8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
