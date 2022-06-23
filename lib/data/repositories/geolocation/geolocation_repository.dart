import 'package:geolocator/geolocator.dart';
import 'package:nativ/data/repositories/geolocation/base_geolocation_repository.dart';

class GeoLocationRepository extends BaseGeoLocationRepository {
  GeoLocationRepository();

  @override
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
