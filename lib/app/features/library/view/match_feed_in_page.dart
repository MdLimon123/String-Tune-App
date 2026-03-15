import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/features/library/view/generate_matched_page.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class MatchFeedInPage extends StatefulWidget {
  const MatchFeedInPage({super.key});

  @override
  State<MatchFeedInPage> createState() => _MatchFeedInPageState();
}

class _MatchFeedInPageState extends State<MatchFeedInPage> {
  String selectedTuning = 'Browse Tuning Library';
  bool showTuningDropdown = false;

  bool isMultiScale = true;

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

  void _showTuningPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
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
            // Drag handle
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
                itemCount: tuningOptions.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Color(0xFF2A2F45), height: 1),
                itemBuilder: (_, i) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    tuningOptions[i],
                    style: TextStyle(
                      color: selectedTuning == tuningOptions[i]
                          ? const Color(0xFF9333EA)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: selectedTuning == tuningOptions[i]
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                  trailing: selectedTuning == tuningOptions[i]
                      ? const Icon(
                          Icons.check,
                          color: Color(0xFF9333EA),
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    setState(() => selectedTuning = tuningOptions[i]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Match Feel In"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Matching From",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 12),
            
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
                    "E Standard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Scale Length: 25.5",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Strings: 6",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Gauge Range: .010–.046",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Total Tension: 118.4 lbs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
           
           
            SizedBox(height: 24),

            // Table Header
            if (isMultiScale) _buildTableHeader(),
            const SizedBox(height: 8),

            if (isMultiScale)
              // String Rows
              ...List.generate(guitarStrings.length, (i) => _buildStringRow(i)),
            const SizedBox(height: 30),

            Text(
              "Which tuning do you want to switch to?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 8),

            GestureDetector(
              onTap: _showTuningPicker,
              child: Container(
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
                      selectedTuning,
                      style: TextStyle(
                        color: selectedTuning == 'Browse Tuning Library'
                            ? const Color(0xFF64748B)
                            : Colors.white,
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
              ),
            ),

            SizedBox(height: 32),
            CustomButton(
              onTap: () {
                Get.to(() => GenerateMatchedPage());
              },
              text: "Generate Matched Gauges",
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(53),
                border: Border.all(color: Color(0xFFD53336), width: 1.5),
              ),
              child: Center(
                child: Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD53336),
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

            Expanded(flex: 2, child: _headerCell('Scale')),

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
    final s = guitarStrings[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF15192B),
        borderRadius: BorderRadius.circular(12),
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

          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(guitarStrings[index]['scale'] as double).toStringAsFixed(1)}"',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
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



}
