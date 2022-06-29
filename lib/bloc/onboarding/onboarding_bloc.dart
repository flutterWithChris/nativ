import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nativ/data/repositories/database_repository.dart';

import '../../data/model/user.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  OnboardingBloc() : super(OnboardingLoading()) {
    on<StartOnboarding>(_startOnboarding);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImages>(_onUpdateUserImages);
  }

  void _startOnboarding(
    StartOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {}

  void _onUpdateUser(
    UpdateUser event,
    Emitter<OnboardingState> emit,
  ) {}

  void _onUpdateUserImages(
    UpdateUserImages event,
    Emitter<OnboardingState> emit,
  ) {}
}
