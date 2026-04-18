import 'package:demo_project/app/core/storage/storage_service.dart';
import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/features/profile/view/aboutus_page.dart';
import 'package:demo_project/app/features/profile/view/personal_info_page.dart';
import 'package:demo_project/app/features/profile/view/privacy_police_page.dart';
import 'package:demo_project/app/features/profile/view/terms_of_service_page.dart';
import 'package:demo_project/app/features/profile/binding/profile_binding.dart';
import 'package:demo_project/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/route_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Image.asset("assets/image/app_logo.png", height: 20, width: 137),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _customListTile(
              onTap: () {
                Get.to(() => PersonalInfoPage(), binding: ProfileBinding());
              },
              image: "assets/icon/person.svg",
              title: 'Profile Information',
            ),
            _customListTile(
              onTap: () {
                Get.to(() => TermsOfServicePage());
              },
              image: "assets/icon/terms.svg",
              title: 'Terms of Services',
            ),
            _customListTile(
              onTap: () {
                Get.to(() => PrivacyPolicePage());
              },
              image: "assets/icon/privacy.svg",
              title: 'Privacy Policy',
            ),
            _customListTile(
              image: "assets/icon/about.svg",
              title: 'About Us',
              onTap: () {
                Get.to(() => AboutusPage());
              },
            ),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                    decoration: const BoxDecoration(
                      color: Color(0xFF020617),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      border: Border(
                        top: BorderSide(color: Color(0xFF9333EA), width: 1.5),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2F45),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Title
                        const Text(
                          'Logout',
                          style: TextStyle(
                            color: Color(0xFFF53838),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Divider(color: Color(0xFFE0E0E0), height: 28),

                        // Message
                        const Text(
                          'Are you sure you want to log out?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Buttons
                        Row(
                          children: [
                            // Cancel
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF020617),
                                    borderRadius: BorderRadius.circular(53),
                                    border: Border.all(
                                      color: const Color(0xFF9333EA),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Color(0xFFD8B4FE),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Yes, Logout
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await StorageService().clear();
                                  await StorageService().removeToken();
                                  await StorageService().removeUserJson();
                                  
                                  Get.offAllNamed(AppRoutes.login);
                                },
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9333EA),
                                    borderRadius: BorderRadius.circular(53),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Yes, Logout',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              leading: SvgPicture.asset('assets/icon/logout.svg'),
              title: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF53838),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customListTile({
    required String image,
    required String title,
    required void Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(image),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFFF8FAFC),
        ),
      ),
      trailing: Icon(Icons.navigate_next, color: Colors.white),
    );
  }
}
