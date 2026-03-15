import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_switch.dart';
import 'package:flutter/material.dart';

class MatchYourSetupPage extends StatefulWidget {
  const MatchYourSetupPage({super.key});

  @override
  State<MatchYourSetupPage> createState() => _MatchYourSetupPageState();
}

class _MatchYourSetupPageState extends State<MatchYourSetupPage> {
  bool isMultiScale = false;
  bool isGuitar = true;
  int numberOfStrings = 6;
  double scaleLength = 25.5;
  bool showTuningDropdown = false;
  bool showStringTypeDropdown = false;
  String selectedTuning = 'Browse Tuning Library';
  String selectedStringType = 'Selected String Type';

  final List<Map<String, dynamic>> guitarStrings = [
    {
      'name': 'e',
      'type': 'P',
      'gauge': 10,
      'tension': '14.3 lbs',
      'scale': 25.5,
    },
    {
      'name': 'A',
      'type': 'P',
      'gauge': 13,
      'tension': '18.7 lbs',
      'scale': 25.5,
    },
    {
      'name': 'D',
      'type': 'P',
      'gauge': 17,
      'tension': '17.9 lbs',
      'scale': 25.5,
    },
    {
      'name': 'G',
      'type': 'P',
      'gauge': 26,
      'tension': '16.8 lbs',
      'scale': 25.5,
    },
    {
      'name': 'B',
      'type': 'P',
      'gauge': 36,
      'tension': '15.4 lbs',
      'scale': 25.5,
    },
    {
      'name': 'E',
      'type': 'P',
      'gauge': 46,
      'tension': '19.2 lbs',
      'scale': 25.5,
    },
  ];

  final List<String> tuningOptions = [
    'E Standard',
    'Eb Standard',
    'D Standard',
    'C# Standard',
    'C Standard',
    'B Standard',
    'A# Standard',
    'A Standard',
    'G# Standard',
    'F Standard',
    'Drop D',
    'Drop C#',
    'Drop C',
    'Drop B',
    'Drop A#',
    'Drop A',
    'Drop G#',
    'Drop G',
    'Drop F#',
    'Drop F',
    'Open E',
    'Open D',
    'Open C',
    'Open G',
    'Open A',
  ];

  final List<Map<String, dynamic>> bassStrings = [
    {
      'name': 'G',
      'type': 'P',
      'gauge': 45,
      'tension': '14.3 lbs',
      'scale': 34.0,
    },
    {
      'name': 'D',
      'type': 'W',
      'gauge': 65,
      'tension': '18.7 lbs',
      'scale': 34.0,
    },
    {
      'name': 'A',
      'type': 'W',
      'gauge': 85,
      'tension': '17.9 lbs',
      'scale': 34.0,
    },
    {
      'name': 'E',
      'type': 'P',
      'gauge': 105,
      'tension': '16.8 lbs',
      'scale': 34.0,
    },
  ];



  List<Map<String, dynamic>> get strings =>
      isGuitar ? guitarStrings : bassStrings;

  final List<String> stringTypeOptions = [
    'Nickel-Wound',
    'Nickel-Plated Steel',
    'Stainless Steel',
    'Half Wound',
    'Flatwound',
  ];

  String _formatGauge(int gauge) {
    if (gauge < 10) return '.00$gauge';
    return '.$gauge';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1F),

      appBar: CustomAppbar(title: 'Match Your Setup'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(child: _label('Instrument')),
                const SizedBox(height: 10),
                Center(child: _buildInstrumentToggle()),
                const SizedBox(height: 24),

                Center(child: _label('Number of Strings')),
                const SizedBox(height: 10),
                Center(
                  child: _buildCounter(
                    value: numberOfStrings.toString(),
                    onDecrement: () => setState(() {
                      if (numberOfStrings > 4) numberOfStrings--;
                    }),
                    onIncrement: () => setState(() {
                      if (numberOfStrings < 12) numberOfStrings++;
                    }),
                  ),
                ),
                const SizedBox(height: 24),

                Center(child: _label('Scale Length')),
                const SizedBox(height: 10),
                Center(
                  child: _buildCounter(
                    value: '${scaleLength.toStringAsFixed(1)}"',
                    onDecrement: () => setState(() {
                      if (scaleLength > 24.0) scaleLength -= 0.5;
                    }),
                    onIncrement: () => setState(() {
                      if (scaleLength < 30.0) scaleLength += 0.5;
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSwitch(
                      value: isMultiScale,
                      onChanged: (value) =>
                          setState(() => isMultiScale = value),
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
                  child: _buildDropdown(selectedStringType),
                ),
                const SizedBox(height: 24),

                _label('Current Tuning'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() {
                    showTuningDropdown = true;
                    showStringTypeDropdown = false;
                  }),
                  child: _buildDropdown(selectedTuning),
                ),
                const SizedBox(height: 24),

                // Total Neck Tension
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
                  child: const Text(
                    'Total Neck Tension: 118.4 lbs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Table Header
                _buildTableHeader(),
                const SizedBox(height: 8),

                // String Rows
                ...List.generate(strings.length, (i) => _buildStringRow(i)),
                const SizedBox(height: 30),

                // Shop Button
                CustomButton(onTap: () {}, text: "Shop This Setup"),
              ],
            ),
          ),

          // Dropdowns overlay
          if (showTuningDropdown || showStringTypeDropdown)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() {
                  showTuningDropdown = false;
                  showStringTypeDropdown = false;
                }),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          if (showTuningDropdown)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomSheet(
                items: tuningOptions,
                onSelect: (item) => setState(() {
                  selectedTuning = item;
                  showTuningDropdown = false;
                }),
              ),
            ),
          if (showStringTypeDropdown)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomSheet(
                items: stringTypeOptions,
                onSelect: (item) => setState(() {
                  selectedStringType = item;
                  showStringTypeDropdown = false;
                }),
              ),
            ),
        ],
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

  Widget _buildInstrumentToggle() {
    return Container(
      width: 154,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2235),
        borderRadius: BorderRadius.circular(58),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleItem(
              'Guitar',
              isGuitar,
              () => setState(() => isGuitar = true),
            ),
          ),
          Expanded(
            child: _toggleItem(
              'Bass',
              !isGuitar,
              () => setState(() => isGuitar = false),
            ),
          ),
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
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
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

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: _headerCell('Strings')),
            Expanded(flex: 3, child: _headerCell('Type')),
            if (isMultiScale) Expanded(flex: 2, child: _headerCell('Scale')),
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

  Widget _buildStringRow(int index) {
    final s = strings[index];
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
          // String name
          Expanded(
            flex: 2,
            child: Text(
              s['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Type P/W buttons
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _typeBtn(
                  'P',
                  s['type'] == 'P',
                  () => setState(() => strings[index]['type'] = 'P'),
                ),
                const SizedBox(width: 6),
                _typeBtn(
                  'W',
                  s['type'] == 'W',
                  () => setState(() => strings[index]['type'] = 'W'),
                ),
              ],
            ),
          ),
          // Scale (multi-scale only)
          if (isMultiScale)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(
                      () => strings[index]['scale'] =
                          (strings[index]['scale'] as double) + 0.5,
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Text(
                    '${(strings[index]['scale'] as double).toStringAsFixed(1)}"',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      double cur = strings[index]['scale'] as double;
                      if (cur > 24.0) strings[index]['scale'] = cur - 0.5;
                    }),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          // Gauge with up/down arrows
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(
                    () => strings[index]['gauge'] =
                        (strings[index]['gauge'] as int) + 1,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Text(
                  _formatGauge(s['gauge'] as int),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    int g = strings[index]['gauge'] as int;
                    if (g > 1) strings[index]['gauge'] = g - 1;
                  }),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          // Tension
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
                    s['tension'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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
              separatorBuilder: (_, __) =>
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
