part of 'signup_bloc.dart';

@immutable
abstract class SignUpEvent extends Equatable {}

class DoSignUpEvent extends SignUpEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;

  DoSignUpEvent(this.email, this.password, this.confirmPassword, this.name);

  @override
  List<Object> get props => [email, password, confirmPassword, name];
}

class DoSignUpGoogleEvent extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class DoSignUpAppleEvent extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class DoVerificationEvent extends SignUpEvent {
  final String verificationCode;
  final String password;
  final String email;
  final String name;

  DoVerificationEvent(
      {this.verificationCode, this.password, this.email, this.name});

  @override
  List<Object> get props => [verificationCode, password, email, name];
}
