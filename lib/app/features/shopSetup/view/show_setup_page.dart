import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/features/tuning/controller/tuning_workbench_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSetupPage extends StatefulWidget {
  const ShowSetupPage({super.key});

  @override
  State<ShowSetupPage> createState() => _ShowSetupPageState();
}

class _ShowSetupPageState extends State<ShowSetupPage> {
  final c = Get.find<TuningWorkbenchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: 'Shop This Setup'),
      body: GetBuilder<TuningWorkbenchController>(
        builder: (_) {
          final packs = c.closestShopPacks;
          if (packs.isEmpty) {
            return const Center(
              child: Text(
                'No matching packs found.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.58,
            ),
            itemCount: packs.length,
            itemBuilder: (context, index) {
              final pack = packs[index];
              return _buildProductCard(
                name: '${pack.brand} ${pack.name}',
                gauge: '${pack.gauges.first} - ${pack.gauges.last}',
                line: pack.line,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String gauge,
    required String line,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 140,
                color: const Color(0xFF0F172A),
                child: Image.asset('assets/image/dummy.png', fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  gauge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      line,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star_rounded, color: Color(0xFF9333EA), size: 16),
                        SizedBox(width: 3),
                        Text(
                          'match',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
