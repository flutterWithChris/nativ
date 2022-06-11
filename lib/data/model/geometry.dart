import 'package:nativ/data/model/location_result.dart';
import 'package:nativ/data/model/viewport_result.dart';

class Geometry {
  final LocationResult locationResult;
  final ViewportResult viewportResult;

  Geometry({required this.locationResult, required this.viewportResult});

  factory Geometry.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Geometry(
      locationResult: LocationResult.fromJson(
        parsedJson['location'],
      ),
      viewportResult: ViewportResult.fromJson(parsedJson['viewport']),
    );
  }
}
