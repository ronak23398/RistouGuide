import 'package:get/get.dart';
import '../../../data/services/firebase_service.dart';

class CitySelectionController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final states = <String>[].obs;
  final cities = <String>[].obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStates();
  }

  Future<void> loadStates() async {
    try {
      isLoading(true);
      states.value = await _firebaseService.getStates();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load states');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadCities(String stateName) async {
    try {
      isLoading(true);
      selectedState.value = stateName;
      cities.value = await _firebaseService.getCitiesByState(stateName);
      selectedCity.value = '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cities');
    } finally {
      isLoading(false);
    }
  }

  void setSelectedCity(String cityName) {
    selectedCity.value = cityName;
  }

  void navigateToHome() {
    if (selectedCity.isNotEmpty) {
      Get.toNamed('/home', arguments: {
        'state': selectedState.value,
        'city': selectedCity.value,
      });
    } else {
      Get.snackbar('Error', 'Please select a city');
    }
  }
}
