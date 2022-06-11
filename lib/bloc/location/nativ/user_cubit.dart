import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void seeDetails() => emit(NativProfileRequested());
  void bookNativ() => emit(NativBookingStarted());
}

class NativBookingStarted extends UserState {}

class NativProfileRequested extends UserState {}

class SearchStarted extends UserState {}
