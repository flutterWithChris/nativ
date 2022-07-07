import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final List<String>? types;
  final String? name, email, photo, username, bio, location;
  final Map<int, String>? reviews;
  final List<String>? specialties;
  final List<String>? visitedPlaces;

  const User(
      {this.id,
      this.name,
      this.email,
      this.photo,
      this.bio,
      this.types,
      this.location,
      this.reviews,
      this.specialties,
      this.username,
      this.visitedPlaces});

  static User fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    User user = User(
        id: snap['id'],
        types: List.from(snap['types']),
        name: snap['name'],
        photo: snap['photo'],
        username: snap['username'],
        email: snap['email'],
        location: snap['location'],
        bio: snap['bio'],
        reviews: Map.from(snap['reviews']),
        specialties: List.from(snap['specialties']),
        visitedPlaces: List.from(snap['visitedPlaces']));
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'photo': photo,
      'email': email,
      'types': types,
      'location': location,
      'bio': bio,
      'reviews': reviews,
      'specialties': specialties,
      'visitedPlaces': visitedPlaces,
    };
  }

  User copyWith({
    String? id,
    List<String>? types,
    String? name,
    String? email,
    String? photo,
    String? username,
    String? bio,
    String? location,
    Map<int, String>? reviews,
    List<String>? specialties,
    List<String>? visitedPlaces,
  }) {
    return User(
      id: id ?? this.id,
      bio: bio ?? this.bio,
      types: types ?? this.types,
      name: name ?? this.name,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      username: username ?? this.username,
      location: location ?? this.location,
      reviews: reviews ?? this.reviews,
      specialties: specialties ?? this.specialties,
      visitedPlaces: visitedPlaces ?? this.visitedPlaces,
    );
  }

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        email,
        name,
        photo,
        username,
        location,
        bio,
        reviews,
        specialties,
        types,
        visitedPlaces,
      ];
}
