import 'package:does_it_doom/app/features/artiset/controller/artist_controller.dart';
import 'package:get/get.dart';

class ArtistBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ArtistController());
  }
}