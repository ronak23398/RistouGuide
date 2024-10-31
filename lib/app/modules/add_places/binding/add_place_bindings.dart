import 'package:get/get.dart';
import '../controllers/add_place_controller.dart';

class AddPlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPlaceController>(
      () => AddPlaceController(),
    );
  }
}
