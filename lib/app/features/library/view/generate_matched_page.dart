import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';

class GenerateMatchedPage extends StatefulWidget {
  const GenerateMatchedPage({super.key});

  @override
  State<GenerateMatchedPage> createState() => _GenerateMatchedPageState();
}

class _GenerateMatchedPageState extends State<GenerateMatchedPage> {

  final List<Map<String, dynamic>> guitarStrings = [
    {
      'name': 'e',
      'type': 'P',
      'gauge': .011,
      'tension': '14.3 lbs',
      'scale': 25.5,
    },
    {
      'name': 'A',
      'type': 'P',
      'gauge': .013,
      'tension': '18.7 lbs',
      'scale': 25.5,
    },
    {
      'name': 'D',
      'type': 'P',
      'gauge': .017,
      'tension': '17.9 lbs',
      'scale': 25.5,
    },
    {
      'name': 'G',
      'type': 'P',
      'gauge': .030,
      'tension': '16.8 lbs',
      'scale': 25.5,
    },
    {
      'name': 'B',
      'type': 'P',
      'gauge': .042,
      'tension': '15.4 lbs',
      'scale': 25.5,
    },
    {
      'name': 'E',
      'type': 'P',
      'gauge': .056,
      'tension': '19.2 lbs',
      'scale': 25.5,
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "C Standard Matched"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Matching From",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
            Text(
              "New Target:C Standard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "TOTAL TENSION",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
                    "Original:118.4 lbs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "New:118.7 lbs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Difference: +0.3%",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check, color: Color(0xFF9333EA)),
                      SizedBox(width: 8),
                      Text(
                        "Feel Matched",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Recommended Gauges",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            _buildTableHeader(),
            const SizedBox(height: 8),

            // String Rows
            ...List.generate(guitarStrings.length, (i) => _buildStringRow(i)),
            const SizedBox(height: 24),
                 Text(
              "STRING-BY-STRING TENSION",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            _buildTableHeader(),
            const SizedBox(height: 8),
            // String Rows
            ...List.generate(guitarStrings.length, (i) => _buildStringRow(i)),
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

            Expanded(flex: 2, child: _headerCell('Old')),

            Expanded(flex: 2, child: _headerCell('New')),
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
                  '${(guitarStrings[index]['gauge'])}',
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
