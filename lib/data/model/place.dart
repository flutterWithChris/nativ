import 'package:nativ/data/model/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String type;

  Place({required this.geometry, required this.name, required this.type});

  factory Place.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['formatted_address'],
      type: parsedJson['types'][0],
    );
  }
}
