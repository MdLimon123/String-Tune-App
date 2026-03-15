import 'package:demo_project/app/features/match/controller/match_your_controller.dart';
import 'package:get/get.dart';

class MatchYourBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MatchYourController());
  }
  
}