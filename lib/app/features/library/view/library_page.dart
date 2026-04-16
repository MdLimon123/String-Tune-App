import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/features/library/view/view_page.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:demo_project/app/features/tuning/domain/tuning_models.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final c = Get.find<TuningWorkbenchController>();
  final _searchController = TextEditingController();

  List<SavedSetup> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return c.savedSetups;
    return c.savedSetups.where((setup) {
      return setup.name.toLowerCase().contains(q) ||
          c.resolveTuningLabel(setup.tuning).toLowerCase().contains(q);
    }).toList();
  }

  void _showRenameDialog(SavedSetup setup) {
    final input = TextEditingController(text: setup.name);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF9333EA), width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Rename Setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: input,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: setup.name,
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFF111827),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF475569)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buttonOutline(
                          text: 'Cancel',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buttonFill(
                          text: 'Save',
                          onTap: () {
                            c.renameSetup(setup.id, input.text);
                            Navigator.of(context).pop();
                          },
                        ),
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

  Widget _buttonOutline({required String text, required VoidCallback onTap}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9333EA), width: 1.5),
        borderRadius: BorderRadius.circular(53),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(53)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFD8B4FE),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buttonFill({required String text, required VoidCallback onTap}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF9333EA),
        borderRadius: BorderRadius.circular(53),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(53)),
        ),
        child: Text(
          text,
          style: const TextStyle(
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
          child: GetBuilder<TuningWorkbenchController>(
            builder: (_) {
              final setups = _filtered;

              return Column(
                children: [
                  TextFormField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hint: const Text(
                        'Search by setup name or tuning....',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      fillColor: const Color(0xFF0F172A),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF94A3B8)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF9D4EDD)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF94A3B8)),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icon/search.svg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: setups.isEmpty
                        ? const Center(
                            child: Text(
                              'No saved setups yet',
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              final setup = setups[index];
                              return _buildTuningCard(setup);
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemCount: setups.length,
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTuningCard(SavedSetup setup) {
    final scale = setup.scaleLength.contains(',')
        ? 'Multi-Scale'
        : '${double.tryParse(setup.scaleLength)?.toStringAsFixed(1) ?? setup.scaleLength}"';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border.all(color: const Color(0xFF9333EA), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    setup.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showRenameDialog(setup),
                      child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => c.deleteSetup(setup.id),
                      child: const Icon(Icons.delete_outline, color: Color(0xFFD53336), size: 20),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Scale Length:', scale),
            const SizedBox(height: 8),
            _buildInfoRow('Strings:', '${setup.stringCount}'),
            const SizedBox(height: 8),
            _buildInfoRow('Gauge Range:', '${setup.gauges.first}-${setup.gauges.last}'),
            const SizedBox(height: 8),
            _buildInfoRow('Tuning:', c.resolveTuningLabel(setup.tuning)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    text: 'Match',
                    fill: true,
                    onTap: () {
                      c.loadSavedSetup(setup);
                      Get.toNamed(AppRoutes.matchYourSetup);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    text: 'View',
                    fill: false,
                    onTap: () => Get.to(() => ViewPage(setup: setup)),
                  ),
                ),
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
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String text,
    required bool fill,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: fill ? const Color(0xFF9333EA) : const Color(0xFF0F172A),
        border: Border.all(
          color: const Color(0xFF9333EA),
          width: fill ? 0 : 1.5,
        ),
        borderRadius: BorderRadius.circular(53),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fill ? Colors.white : const Color(0xFFD8B4FE),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
