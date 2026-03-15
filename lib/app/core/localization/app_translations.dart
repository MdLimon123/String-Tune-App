import 'package:get/get.dart';

import 'languages/en_us.dart';
import 'languages/ar_sa.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'ar_SA': arSa,
      };
}
