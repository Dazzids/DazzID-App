part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class AuthShowWelcomeEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthShowLoginEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthShowSignUpEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthShowSessionEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthShowAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthShowVerificationEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthShowErrorEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
