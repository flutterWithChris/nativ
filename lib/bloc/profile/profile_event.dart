part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final User user;

  const UpdateProfile({
    required this.user,
  });

  @override
  // TODO: implement props
  List<Object> get props => [user];
}
