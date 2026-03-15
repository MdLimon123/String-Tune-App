import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/features/library/view/match_feed_in_page.dart';
import 'package:demo_project/app/features/library/view/view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/route_manager.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  void _showRenameDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF9333EA), width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Rename Setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Text Field
                  CustomTextField(hintText: "E Standard"),

                  SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _buildCancelButton(() {
                          Navigator.of(context).pop();
                        }),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildSaveButton(() {
                          Navigator.of(context).pop();
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCancelButton(VoidCallback onTap) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF9333EA), width: 1.5),
        borderRadius: BorderRadius.circular(53),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(53),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Color(0xFFD8B4FE),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(VoidCallback onTap) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xFF9333EA),
        borderRadius: BorderRadius.circular(53),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(53),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/image/app_logo.png', height: 20, width: 137),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hint: Text(
                    'Search by artist, band, or tuning....',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  fillColor: Color(0xFF0F172A),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    borderSide: BorderSide(color: Color(0xFF94A3B8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    borderSide: BorderSide(color: Color(0xFF9D4EDD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    borderSide: BorderSide(color: Color(0xFF94A3B8)),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icon/search.svg'),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return _buildTuningCard(
                      tuningName: 'E Standard',
                      scaleLength: "25.5'",
                      strings: '6',
                      gaugeRange: '.010-.046',
                      totalTension: '118.4 lbs',
                      onEdit: () => _showRenameDialog(),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTuningCard({
    required String tuningName,
    required String scaleLength,
    required String strings,
    required String gaugeRange,
    required String totalTension,
    required VoidCallback onEdit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border.all(color: Color(0xFF9333EA), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and edit icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tuningName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Info rows
            _buildInfoRow('Scale Length:', scaleLength),
            SizedBox(height: 8),
            _buildInfoRow('Strings:', strings),
            SizedBox(height: 8),
            _buildInfoRow('Gauge Range:', gaugeRange),
            SizedBox(height: 8),
            _buildInfoRow('Total Tension:', totalTension),
            SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(child: _buildMatchButton()),
                SizedBox(width: 12),
                Expanded(child: _buildViewButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFF9333EA),
        borderRadius: BorderRadius.circular(53),
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => MatchFeedInPage());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Match',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildViewButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border.all(color: Color(0xFF9333EA), width: 1.5),
        borderRadius: BorderRadius.circular(53),
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => ViewPage());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'View',
          style: TextStyle(
            color: Color(0xFFD8B4FE),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
