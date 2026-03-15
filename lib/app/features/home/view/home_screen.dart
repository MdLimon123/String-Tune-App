import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/image/app_logo.png',
                  height: 20,
                  width: 137,
                ),
                SizedBox(height: 32),

                _customContainer(
                  title: "Calculate",
                  subtitle: "Tension Calculator",
                  text: "Calculate string tension instantly",
                  image: 'assets/image/1 25.png',
                  onTap: () {
                    Get.toNamed(AppRoutes.calculate);
                  },
                ),

                SizedBox(height: 20),
                _customContainer(
                  title: "Feel-Based",
                  subtitle: "Match My Feel",
                  text: "Keep your exact feel in any tuning",
                  image: 'assets/image/2 6.png',
                  onTap: () {
                    Get.toNamed(AppRoutes.matchYourSetup);
                  },
                ),
                SizedBox(height: 20),
                _customContainer(
                  title: "New Setup",
                  subtitle: "Build A Setup",
                  text: "Choose loose, balanced, or tight — get gauges",
                  image: 'assets/image/3 1.png',
                  onTap: () {
                    Get.toNamed(AppRoutes.buildSetup);
                  },
                ),
                SizedBox(height: 20),
                _customContainer(
                  title: "Artist Tunings",
                  subtitle: "Load A Legend's Setup",
                  text: "Play legendary setups on your guitar",
                  image: 'assets/image/layer_1.png',
                  onTap: () {
                    Get.toNamed(AppRoutes.artistTunings);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customContainer({
    required String title,
    required String subtitle,
    required String text,
    required String image,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6B46A0), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA070D0),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                height: double.infinity,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
