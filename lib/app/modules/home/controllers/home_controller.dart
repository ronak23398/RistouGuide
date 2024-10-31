import 'package:get/get.dart';
import 'package:myapp/app/data/model/place_model.dart';
import '../../../data/services/firebase_service.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final selectedState = ''.obs;
  final selectedCity = ''.obs;
  final attractions = <Place>[].obs;
  final foodPlaces = <Place>[].obs;
  final shoppingPlaces = <Place>[].obs;
  final isLoading = false.obs;
  final favoritePlaces = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      selectedState.value = args['state'];
      selectedCity.value = args['city'];
      loadAllPlaces();
    }
  }

  Future<void> loadAllPlaces() async {
    isLoading(true);
    try {
      await Future.wait([
        loadAttractions(),
        loadFoodPlaces(),
        loadShoppingPlaces(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadAttractions() async {
    try {
      attractions.value = await _firebaseService.getPlacesByType(
          selectedState.value, selectedCity.value, 'attractions');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load attractions');
    }
  }

  Future<void> loadFoodPlaces() async {
    try {
      foodPlaces.value = await _firebaseService.getPlacesByType(
          selectedState.value, selectedCity.value, 'food');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load food places');
    }
  }

  Future<void> loadShoppingPlaces() async {
    try {
      shoppingPlaces.value = await _firebaseService.getPlacesByType(
          selectedState.value, selectedCity.value, 'shopping');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load shopping places');
    }
  }

  void toggleFavorite(String placeId) {
    if (favoritePlaces.contains(placeId)) {
      favoritePlaces.remove(placeId);
    } else {
      favoritePlaces.add(placeId);
    }
  }

  void navigateToPlaceDetails(Place place) {
    Get.toNamed('/place-details', arguments: place);
  }

  void navigateToAddPlace() {
    Get.toNamed('/add-place', arguments: {
      'state': selectedState.value,
      'city': selectedCity.value,
    });
  }
}
