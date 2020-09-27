import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longtitude;
  Location({
    this.latitude,
    this.longtitude,
  });

  Future<void> getCurrentLocation() async {
    try {
      Position position = await GeolocatorPlatform.instance
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .timeout(Duration(seconds: 5));
      latitude = position.latitude;
      longtitude = position.longitude;
    } catch (e) {
      throw "Something goes wrong: $e";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longtitude': longtitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Location(
      latitude: map['latitude'],
      longtitude: map['longtitude'],
    );
  }
}
