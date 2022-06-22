import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nativ/data/model/user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadProfile>((event, emit) => _onLoadProfile);
    on<UpdateProfile>((event, emit) => _onUpdateProfile);
  }
}

void _onLoadProfile(
  LoadProfile event,
  Emitter<ProfileState> emit,
) {}

void _onUpdateProfile(
  UpdateProfile event,
  Emitter<ProfileState> emit,
) {}
