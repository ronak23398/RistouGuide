import 'package:get/get.dart';
import 'package:myapp/app/data/model/place_model.dart';

class PlaceDetailsController extends GetxController {
  final place = Rx<Place?>(null);
  final currentImageIndex = 0.obs;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Place) {
      place.value = args;
      // In a real app, you'd check if this place is in favorites
      // and set isFavorite accordingly
    }
  }

  void toggleFavorite() {
    isFavorite.toggle();
    // In a real app, you'd persist this change
  }

  void nextImage() {
    if (place.value != null &&
        currentImageIndex < place.value!.images.length - 1) {
      currentImageIndex.value++;
    }
  }

  void previousImage() {
    if (currentImageIndex > 0) {
      currentImageIndex.value--;
    }
  }

  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }
}
