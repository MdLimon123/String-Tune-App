import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/features/bottomNavbar/controller/bottom_navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavbarScreen extends StatelessWidget {
  const BottomNavbarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavbarController>();

    return GetBuilder<BottomNavbarController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background,

      
          body: controller.pages[controller.index],

    
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(top: 12, bottom: 20, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Color(0xFF0F172A),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: "assets/icon/home.svg",
                  label: "Home",
                  index: 0,
                  controller: controller,
                ),
                _buildNavItem(
                  icon: "assets/icon/library.svg",
                  label: "Library",
                  index: 1,
                  controller: controller,
                ),
                _buildNavItem(
                  icon: "assets/icon/shop.svg",
                  label: "Shop",
                  index: 2,
                  controller: controller,
                ),
                _buildNavItem(
                  icon: "assets/icon/settings.svg",
                  label: "Settings",
                  index: 3,
                  controller: controller,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
    required BottomNavbarController controller,
  }) {
    bool isSelected = controller.index == index;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              isSelected ? Colors.white : Color(0xFF334155),
              BlendMode.srcIn,
            ),
            height: 26,
          ),

     
          if (isSelected) ...[
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
