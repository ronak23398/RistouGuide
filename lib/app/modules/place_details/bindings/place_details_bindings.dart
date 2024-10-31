import 'package:get/get.dart';
import '../controllers/place_details_controller.dart';

class PlaceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceDetailsController>(
      () => PlaceDetailsController(),
    );
  }
}
