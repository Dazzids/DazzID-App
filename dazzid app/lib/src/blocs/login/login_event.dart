part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class DoLoginEvent extends LoginEvent {
  final String email;
  final String password;

  DoLoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class DoLoginGoogleEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class DoLoginAppleEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LogOutEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}
