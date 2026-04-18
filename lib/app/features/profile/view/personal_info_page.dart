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
  void initState() {
    super.initState();
    Get.find<ProfileController>().fetchProfile();
  }

  Widget _buildAvatar(ProfileController c) {
    if (c.validProfileImage != null) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade500),
          image: DecorationImage(
            image: FileImage(c.validProfileImage!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.30),
              BlendMode.darken,
            ),
          ),
        ),
      );
    }

    final url = c.remoteImageUrl;
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholderAvatar(),
        ),
      );
    }

    return _placeholderAvatar();
  }

  Widget _placeholderAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/image/user.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Profile Information"),
      body: GetBuilder<ProfileController>(
        builder: (c) {
          if (c.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF9333EA),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading profile…',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (c.errorMessage != null && c.errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Text(
                    c.errorMessage!,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Obx(() {
                                final pc = Get.find<ProfileController>();
                                return _buildAvatar(pc);
                              }),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    Get.find<ProfileController>().pickUserProfileImage();
                                  },
                                  child: Image.asset('assets/image/edit.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                        controller: c.nameController,
                        readOnly: false,
                        prefixIcon: SvgPicture.asset('assets/icon/user.svg'),
                        hintText: 'Your name',
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
                        controller: c.emailController,
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF64748B),
                          size: 20,
                        ),
                        prefixIcon: SvgPicture.asset('assets/icon/email.svg'),
                        hintText: '—',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: CustomButton(
                  loading: c.saving,
                  onTap: () => c.updateProfile(),
                  text: 'Save',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
