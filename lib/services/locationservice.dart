import 'dart:async';
import 'package:codimappp/model/user_location.dart';
import 'package:location/location.dart';

class LocationService {
  
  // Keep track of current Location
  UserLocation? _currentLocation;
  Location location = Location();

  // Continuously emit location updates
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          
            _locationController.add(UserLocation(
              latitude: locationData.latitude!,
              longitude: locationData.longitude!,
              accuracy: locationData.accuracy!,
            ));
          
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude!,
        longitude: userLocation.longitude!,
        accuracy: userLocation.accuracy!
      );
    } catch (e) {
      print('Could not get the location: $e');
    }
    return _currentLocation!;
  }
}