import 'dart:io';

import 'package:demo_project/app/core/utils/image_utils.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  Rx<File?> profileImage = Rx<File?>(null);

  File? get validProfileImage {
    if (profileImage.value == null) return null;
    if (!profileImage.value!.existsSync()) {
      profileImage.value = null;
      return null;
    }
    return profileImage.value;
  }


  Future<void> pickUserProfileImage({bool fromCamera = false}) async {
    final pickedFile = await ImageUtils.pickAndCropImage(
      fromCamera: fromCamera,
    );

    if (pickedFile != null && pickedFile.existsSync()) {
      profileImage.value = pickedFile;
    }
  }

}