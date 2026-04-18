import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils{

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickAndCropImage({bool fromCamera = false})async{

   try{
     final pickedFile = await _picker.pickImage(
       source: fromCamera? ImageSource.camera : ImageSource.gallery,
     );

     if(pickedFile == null) return null;

     final appDir = await getApplicationDocumentsDirectory();
     final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
     final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

     return savedImage;

   }catch(e){
     debugPrint("Image Pick/Crop Error: $e");
     return null;
   }

  }

}
