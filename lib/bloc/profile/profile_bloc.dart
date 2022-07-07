import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nativ/bloc/app/app_bloc.dart';
import 'package:nativ/data/model/user.dart';
import 'package:nativ/data/repositories/database_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppBloc _appBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;

  ProfileBloc({
    required AppBloc appBloc,
    required DatabaseRepository databaseRepository,
  })  : _appBloc = appBloc,
        _databaseRepository = databaseRepository,
        super(ProfileLoading()) {
    on<LoadProfile>((event, emit) {
      {
        _databaseRepository.getUser(event.userId).listen((user) {
          add(UpdateProfile(user: user));
        });
      }
    });
    on<UpdateProfile>((event, emit) {
      print('${event.user} loaded');
      emit(ProfileLoaded(user: event.user));
    });

    _authSubscription = _appBloc.stream.listen((state) {
      add(LoadProfile(userId: state.user.id!));
    });
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) {}

  void _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) {
    print('${event.user} loaded');
    emit(ProfileLoaded(user: event.user));
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _authSubscription?.cancel();
    return super.close();
  }
}
