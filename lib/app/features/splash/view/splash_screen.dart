import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: GetBuilder<SplashController>(
        builder: (controller) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                Center(child: Image.asset("assets/image/app_logo.png")),
                SizedBox(height: 24),
                Center(
                  child: Text(
                    "Guitar & Bass String Tension Calculator",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'by',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF1F5F9),
                      ),
                    ),
                    Text(
                      " Does It Doom",
                      style: TextStyle(
                        color: Color(0xFF9333EA),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
