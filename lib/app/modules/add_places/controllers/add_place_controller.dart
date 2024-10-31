import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

class AddPlaceController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final ratingController = TextEditingController();
  
  final selectedState = ''.obs;
  final selectedCity = ''.obs;
  final selectedCategory = ''.obs;
  final isLoading = false.obs;
  final imageFiles = <File>[].obs;
  
  final categories = ['Attractions', 'Food', 'Shopping'];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      selectedState.value = args['state'];
      selectedCity.value = args['city'];
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    ratingController.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      
      if (pickedFiles.isNotEmpty) {
        imageFiles.addAll(pickedFiles.map((file) => File(file.path)));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images');
    }
  }

  void removeImage(int index) {
    imageFiles.removeAt(index);
  }

  Future<List<String>> uploadImages() async {
    List<String> uploadedUrls = [];
    
    for (File imageFile in imageFiles) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${uploadedUrls.length}.jpg';
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('places')
          .child(selectedState.value)
          .child(selectedCity.value)
          .child(fileName);

      try {
        await storageRef.putFile(imageFile);
        String downloadUrl = await storageRef.getDownloadURL();
        uploadedUrls.add(downloadUrl);
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload image');
        rethrow;
      }
    }
    
    return uploadedUrls;
  }

  String? validateRating(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a rating';
    }
    final rating = double.tryParse(value);
    if (rating == null || rating < 0 || rating > 5) {
      return 'Rating must be between 0 and 5';
    }
    return null;
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;
    if (imageFiles.isEmpty) {
      Get.snackbar('Error', 'Please add at least one image');
      return;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }

    try {
      isLoading(true);
      
      // Upload images and get URLs
      final List<String> imageUrls = await uploadImages();
      
      // Prepare place data
      final placeData = {
        'title': titleController.text,
        'description': descriptionController.text,
        'address': addressController.text,
        'rating': double.parse(ratingController.text),
        'images': imageUrls,
        'timestamp': ServerValue.timestamp,
      };

      // Get reference to Firebase database
      final dbRef = FirebaseDatabase.instance.ref()
          .child('india')
          .child('states')
          .child(selectedState.value)
          .child('cities')
          .child(selectedCity.value)
          .child(selectedCategory.value.toLowerCase())
          .push();

      // Save data
      await dbRef.set(placeData);
      
      Get.back();
      Get.snackbar('Success', 'Place added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add place');
    } finally {
      isLoading(false);
    }
  }
}
