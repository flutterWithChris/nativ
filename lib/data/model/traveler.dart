import 'package:equatable/equatable.dart';

class Traveler extends Equatable {
  final String id;
  final String? name, email, photo, location, bio;

  const Traveler({required this.id, this.name, this.email, this.photo, this.bio, this.location});

  static const empty = Traveler(id: '');

  bool get isEmpty => this == Traveler.empty;
  bool get isNotEmpty => this != Traveler.empty;

  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, photo];
}
