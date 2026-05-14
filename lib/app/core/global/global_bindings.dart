import 'package:get/get.dart';

import 'package:does_it_doom/app/core/global/loading_controller.dart';
import 'package:does_it_doom/app/core/theme/theme_controller.dart';
import 'package:does_it_doom/app/core/localization/localization_controller.dart';
import 'package:does_it_doom/app/features/calculate/controller/calculate_controller.dart';
import 'package:does_it_doom/app/features/tuning/controller/tuning_workbench_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(LocalizationController(), permanent: true);
    Get.put(TuningWorkbenchController(), permanent: true);
    Get.put(CalculateController(), permanent: true);
  }
}
