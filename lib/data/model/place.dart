import 'package:nativ/data/model/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final List<String> types;

  Place({required this.geometry, required this.name, required this.types});

  factory Place.fromJson(Map<dynamic, dynamic> parsedJson) {
    var typesfromJson = parsedJson['types'];
    List<String> typesList = List<String>.from(typesfromJson);
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['formatted_address'],
      types: typesList,
    );
  }
}
