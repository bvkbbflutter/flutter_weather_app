import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../errors/exceptions.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Location services are disabled. Please enable them.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permissions are permanently denied. Please enable them in settings.',
      );
    }

    // return Geolocator.getCurrentPosition(
    //   locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    // );
    // return Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.medium,
    // );
    // return Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.medium,
    //   locationSettings: ,
    //   timeLimit: ,
    //   forceAndroidLocationManager: true, // Add this for Android
    // );
    return await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
        forceLocationManager: false,
        timeLimit: Duration(seconds: 20),
      ),
    );
  }

  Future<String> getCityFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.locality ?? place.administrativeArea ?? 'Unknown';
      }
      return 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }
}
