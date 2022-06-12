import 'package:geolocator/geolocator.dart';
import 'package:nativ/data/repositories/geolocation/base_geolocation_repository.dart';

class GeoLocationRepository extends BaseGeoLocationRepository {
  GeoLocationRepository();

  @override
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
