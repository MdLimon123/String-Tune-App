import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:demo_project/app/core/utils/custom_button.dart';
import 'package:demo_project/app/core/utils/custom_text_field.dart';
import 'package:demo_project/app/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Profile Information"),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image
                  Obx(() {
                    final controller = Get.find<ProfileController>();
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        controller.validProfileImage == null
                            ? Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/image/user.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.shade500
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(
                                        controller.validProfileImage!,
                                      ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withValues(alpha: 0.30),
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 120,
                          child: InkWell(
                            onTap: () {
                              controller.pickUserProfileImage();
                            },
                            child: Image.asset('assets/image/edit.png'),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),
                  const Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    prefixIcon: SvgPicture.asset('assets/icon/user.svg'),
                    hintText: 'Dianne Russell',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    readOnly: true,
                    suffixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    prefixIcon: SvgPicture.asset('assets/icon/email.svg'),
                    hintText: 'dianne.russell@example.com',
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: CustomButton(onTap: () {}, text: "Save"),
          ),
        ],
      ),
    );
  }
}
