//model for userlocation to be used in provider

class UserLocation {
  final double latitude;
  final double longitude;
  final double accuracy;

  UserLocation(
      {required this.latitude,
      required this.longitude,
      required this.accuracy});
}
