import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? name, email, photo;

  const User({required this.id, this.name, this.email, this.photo});

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, photo];
}
