import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:myapp/app/data/model/place_model.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _cachePrefix = 'places_cache_';
  static const Duration _cacheDuration = Duration(hours: 24);

  // Fetch states with caching
  Future<List<String>> getStates() async {
    try {
      // Check cache first
      final prefs = await SharedPreferences.getInstance();
      const cacheKey = '${_cachePrefix}states';
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final cacheTime = prefs.getInt('${cacheKey}_time');
        if (cacheTime != null &&
            DateTime.now().millisecondsSinceEpoch - cacheTime <
                _cacheDuration.inMilliseconds) {
          return List<String>.from(jsonDecode(cachedData));
        }
      }

      // Fetch fresh data if cache is invalid or missing
      final snapshot = await _database.child('india/states').get();
      if (snapshot.exists) {
        final states = Map<String, dynamic>.from(snapshot.value as Map)
            .values
            .map((state) => state['name'].toString())
            .toList();

        // Update cache
        await prefs.setString(cacheKey, jsonEncode(states));
        await prefs.setInt(
            '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

        return states;
      }
      return [];
    } catch (e) {
      print('Error fetching states: $e');
      return [];
    }
  }

  // Fetch cities by state with caching
  Future<List<String>> getCitiesByState(String stateName) async {
    try {
      // Check cache first
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '${_cachePrefix}cities_$stateName';
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final cacheTime = prefs.getInt('${cacheKey}_time');
        if (cacheTime != null &&
            DateTime.now().millisecondsSinceEpoch - cacheTime <
                _cacheDuration.inMilliseconds) {
          return List<String>.from(jsonDecode(cachedData));
        }
      }

      // Fetch fresh data if cache is invalid or missing
      final snapshot = await _database
          .child('india/states')
          .orderByChild('name')
          .equalTo(stateName)
          .get();

      if (snapshot.exists) {
        final states = Map<String, dynamic>.from(snapshot.value as Map);
        final state = states.values.first;

        if (state['cities'] != null) {
          final cities = Map<String, dynamic>.from(state['cities'] as Map)
              .values
              .map((city) => city['name'].toString())
              .toList();

          // Update cache
          await prefs.setString(cacheKey, jsonEncode(cities));
          await prefs.setInt(
              '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

          return cities;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }

  // Fetch places by type (attractions/food/shopping) with caching
  Future<List<Place>> getPlacesByType(
      String stateName, String cityName, String type) async {
    try {
      // Check cache first
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix${stateName}_${cityName}_$type';
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final cacheTime = prefs.getInt('${cacheKey}_time');
        if (cacheTime != null &&
            DateTime.now().millisecondsSinceEpoch - cacheTime <
                _cacheDuration.inMilliseconds) {
          final List<dynamic> decoded = jsonDecode(cachedData);
          return decoded.map((item) => Place.fromJson(item)).toList();
        }
      }

      // Fetch fresh data if cache is invalid or missing
      final path = 'india/states/$stateName/cities/$cityName/$type';
      final snapshot = await _database.child(path).get();

      if (snapshot.exists) {
        final placesData = Map<String, dynamic>.from(snapshot.value as Map);
        final places = placesData.entries.map((entry) {
          final placeData = Map<String, dynamic>.from(entry.value as Map);
          placeData['id'] = entry.key;
          return Place.fromJson(placeData);
        }).toList();

        // Update cache
        await prefs.setString(
            cacheKey, jsonEncode(places.map((p) => p.toJson()).toList()));
        await prefs.setInt(
            '${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

        return places;
      }
      return [];
    } catch (e) {
      print('Error fetching places: $e');
      return [];
    }
  }

  // Helper method to get image URLs from Firebase Storage
  Future<List<String>> getImageUrls(List<String> imagePaths) async {
    try {
      final urls = await Future.wait(
          imagePaths.map((path) => _storage.ref(path).getDownloadURL()));
      return urls;
    } catch (e) {
      print('Error fetching image URLs: $e');
      return [];
    }
  }

  // Add a new place
  Future<bool> addPlace(
      String stateName, String cityName, String type, Place place) async {
    try {
      final path = 'india/states/$stateName/cities/$cityName/$type';
      final newPlaceRef = _database.child(path).push();
      await newPlaceRef.set(place.toJson());

      // Invalidate cache for this location and type
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix${stateName}_${cityName}_$type';
      await prefs.remove(cacheKey);
      await prefs.remove('${cacheKey}_time');

      return true;
    } catch (e) {
      print('Error adding place: $e');
      return false;
    }
  }
}
