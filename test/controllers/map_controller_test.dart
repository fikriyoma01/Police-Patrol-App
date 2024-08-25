// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:police_patrol_app/services/location_service.dart';
// import 'package:get/get.dart';
// import 'package:location/location.dart';
// import 'package:police_patrol_app/views/map_page.dart';

// class MockLocationService extends Mock implements LocationService {
//   @override
//   Stream<LocationData> get locationStream => Stream<LocationData>.periodic(
//         Duration(seconds: 1),
//         (count) => LocationData.fromMap({
//           "latitude": 37.42796133580664,
//           "longitude": -122.085749655962,
//         }),
//       ).take(2); 
// }

// void main() {
//   group('MapController Tests', () {
//     late MapController mapController;
//     late MockLocationService mockLocationService;

//     setUp(() {
//       mockLocationService = MockLocationService();
//       mapController = MapController();
//       Get.put(mapController); // Register the controller in GetX dependency injection
//     });

//     test('Test startRouteRecording adds location points to _currentRoute', () async {
//       // Start recording route
//       mapController.startRecording();

//       // Wait for location stream to add points to _currentRoute
//       await Future.delayed(Duration(seconds: 3));

//       // Validate that _currentRoute contains the points from the location stream
//       expect(mapController.currentRoute.length, 2);
//       expect(mapController.currentRoute.first.latitude, 37.42796133580664);
//       expect(mapController.currentRoute.first.longitude, -122.085749655962);
//     });
//   });
// }
