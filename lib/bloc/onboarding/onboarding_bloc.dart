import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nativ/data/repositories/database_repository.dart';
import 'package:nativ/data/repositories/storage/storage_repository.dart';

import '../../data/model/user.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;

  OnboardingBloc(
      {required this.databaseRepository, required this.storageRepository})
      : super(OnboardingLoading()) {
    on<StartOnboarding>(_onStartOnboarding);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImages>(_onUpdateUserImages);
  }

  void _onStartOnboarding(
    StartOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await databaseRepository.createUser(event.user);
    emit(OnboardingLoaded(user: event.user));
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      databaseRepository.updateUser(event.user);
      emit(OnboardingLoaded(user: event.user));
    }
  }

  void _onUpdateUserImages(
    UpdateUserImages event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingLoaded) {
      User user = (state as OnboardingLoaded).user;

      await storageRepository.uploadImage(user, event.image);

      databaseRepository.getUser(user.id!).listen((user) {
        add(UpdateUser(user: user));
      });
    }
  }
}
