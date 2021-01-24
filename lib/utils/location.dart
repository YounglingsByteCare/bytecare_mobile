import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  permission = await getLocationPermissionState();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permission are permanently denied, we cannot request '
        'permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await requestLocationPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error('Location permissions are denied (actual value: '
          '$permission');
    }
  }

  return await Geolocator.getCurrentPosition();
}

Future<LocationPermission> getLocationPermissionState() async =>
    await Geolocator.checkPermission();

Future<LocationPermission> requestLocationPermission() async =>
    await Geolocator.requestPermission();
