import 'package:get/get.dart';
import '../controllers/city_selection_controller.dart';

class CitySelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CitySelectionController>(
      () => CitySelectionController(),
    );
  }
}
