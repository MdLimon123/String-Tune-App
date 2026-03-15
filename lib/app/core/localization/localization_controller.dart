import 'dart:ui';

import 'package:get/get.dart';

import 'package:demo_project/app/core/storage/storage_service.dart';

class LocalizationController extends GetxController {
  final _storage = StorageService();
  final _locale = const Locale('en', 'US').obs;

  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    final saved = _storage.getLanguageCode();
    if (saved != null && saved.contains('_')) {
      final parts = saved.split('_');
      _locale.value = Locale(parts[0], parts[1]);
    }
  }

  void changeLocale(String languageCode, String countryCode) {
    final newLocale = Locale(languageCode, countryCode);
    _locale.value = newLocale;
    Get.updateLocale(newLocale);
    _storage.saveLanguageCode('${languageCode}_$countryCode');
  }

  void toggleLocale() {
    if (_locale.value.languageCode == 'en') {
      changeLocale('ar', 'SA');
    } else {
      changeLocale('en', 'US');
    }
  }

  bool get isArabic => _locale.value.languageCode == 'ar';
}
