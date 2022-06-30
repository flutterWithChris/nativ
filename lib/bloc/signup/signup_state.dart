part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String email, password;
  bool get isEmailValid => email.contains('@');
  bool get isConfirmEmailValid => email.contains('@');
  bool get isPasswordValid => password.length > 5;
  bool isTraveler = false;
  bool isNativ = false;
  firebase_auth.User? user;
  final SignupStatus status;

  SignupState(
      {required this.email,
      required this.password,
      required this.status,
      required this.isNativ,
      required this.isTraveler,
      this.user});

  factory SignupState.initial() {
    return SignupState(
        email: '',
        password: '',
        isNativ: false,
        isTraveler: false,
        status: SignupStatus.initial,
        user: null);
  }

  SignupState copyWith({
    String? email,
    String? password,
    SignupStatus? status,
    bool? isNativ,
    bool? isTraveler,
    firebase_auth.User? user,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isNativ: isNativ ?? this.isNativ,
      isTraveler: isTraveler ?? this.isTraveler,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        status,
      ];
}
