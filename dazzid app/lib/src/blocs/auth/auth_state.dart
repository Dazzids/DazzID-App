part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthWelcomeState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoginState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSignUpState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthVerificationState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSessionState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthReLoginState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  @override
  List<Object> get props => [];
}
