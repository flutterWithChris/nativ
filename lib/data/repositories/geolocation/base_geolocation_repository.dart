import 'package:geolocator/geolocator.dart';

abstract class BaseGeoLocationRepository {
  Future<Position?> getCurrentLocation() async {
    return null;
  }
}
