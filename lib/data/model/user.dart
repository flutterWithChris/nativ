import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String id;
  final String? name, email, photo, username, bio, location;
  final Map<int, String>? reviews;
  final Map<Icon, String>? specialties;

  const User(
      {required this.id,
      this.name,
      this.email,
      this.photo,
      this.bio,
      this.location,
      this.reviews,
      this.specialties,
      this.username});

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, email, name, photo, username, location, bio, reviews, specialties];
}
