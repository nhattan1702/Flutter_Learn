
import 'package:geolocator/geolocator.dart';

class Location {

  late double latitude;
  late double longtitude;

   final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.low,
    distanceFilter: 100,
  );

  Future<void> getCurrenLoaction () async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      latitude = position.latitude;
      longtitude = position.longitude;

    } catch (e) {
    }
  }

}