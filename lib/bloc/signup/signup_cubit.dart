import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:nativ/data/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit(this._authRepository) : super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void isTraveler(bool value) {
    emit(state.copyWith(isTraveler: value));
  }

  void isNativ(bool value) {
    emit(state.copyWith(isNativ: value));
  }

  void isBoth(bool value) {
    emit(state.copyWith(isNativ: value, isTraveler: value));
  }

  Future<void> signupFormSubmitted() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(
      status: SignupStatus.submitting,
    ));
    try {
      var user = await _authRepository.signUp(
          email: state.email, password: state.password);
      emit(state.copyWith(status: SignupStatus.success, user: user));
    } catch (_) {
      emit(state.copyWith(
        status: SignupStatus.error,
      ));
    }
  }

  Future<void> signUpWithGoogleCredentials() async {
    if (state.status == SignupStatus.submitting) {
      emit(state.copyWith(status: SignupStatus.submitting));
    }
    try {
      var user = await _authRepository.signUpWithGoogle();
      emit(state.copyWith(status: SignupStatus.success, user: user));
    } catch (_) {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
