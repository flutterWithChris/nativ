import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Nativ extends Equatable {
  final String id;
  final String? name, email, photo, bio, location;
  final Map<int, String>? reviews;
  final Map<Icon, String>? specialties;

  const Nativ(
      {required this.id,
      this.name,
      this.email,
      this.photo,
      this.bio,
      this.location,
      this.reviews,
      this.specialties});

  static const empty = Nativ(id: '');

  bool get isEmpty => this == Nativ.empty;
  bool get isNotEmpty => this != Nativ.empty;

  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, photo];
}
