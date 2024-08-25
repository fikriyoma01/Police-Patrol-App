import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  // Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await _location.serviceEnabled();
  }

  // Request location service permission
  Future<bool> requestLocationPermission() async {
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // Get the current location
  Future<LocationData?> getCurrentLocation() async {
    try {
      return await _location.getLocation();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Track location changes
  Stream<LocationData> get locationStream => _location.onLocationChanged;
}
