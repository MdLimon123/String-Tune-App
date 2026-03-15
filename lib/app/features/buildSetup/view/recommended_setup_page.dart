import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:flutter/material.dart';

class RecommendedSetupPage extends StatefulWidget {
  final bool isMultiScale;
  final bool isGuitar;
  const RecommendedSetupPage({super.key, required this.isMultiScale, required this.isGuitar});

  @override
  State<RecommendedSetupPage> createState() => _RecommendedSetupPageState();
}

class _RecommendedSetupPageState extends State<RecommendedSetupPage> {
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
     widget.isGuitar ? guitarStrings : bassStrings;



  String _formatGauge(int gauge) {
    if (gauge < 10) return '.00$gauge';
    return '.$gauge';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Recommended Setup"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Optimized for C Standard at 25.5”",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Recommended Gauge Set & Tension",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            _buildTableHeader(),
            const SizedBox(height: 8),

            // String Rows
            ...List.generate(strings.length, (i) => _buildStringRow(i)),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Neck Tension:124.6 lbs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "String Type:Nickel Wound",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Tension Feel:Tight & Precise",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Gauges:.010 – .046",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
            CustomButton(onTap: () {}, text: "Save"),
            SizedBox(height: 16),

            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF9333EA)),
                borderRadius: BorderRadius.circular(53),
              ),
              child: Center(
                child: Text(
                  "Shop This Setup",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD8B4FE),
                  ),
                ),
              ),
            ),
          ],
        ),
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
            if (widget.isMultiScale)
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
          if (widget.isMultiScale)
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
}
