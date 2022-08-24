part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

// Show loading widget
class LogginInState extends LoginState {
  @override
  List<Object> get props => [];
}

//Logged
class LoggedInState extends LoginState {
  final String token;

  LoggedInState(this.token);

  @override
  List<Object> get props => [token];
}

class DoLogOutState extends LoginState {
  @override
  List<Object> get props => [];
}

class LogOutSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}

//login error
class ErrorLoginState extends LoginState {
  final String message;

  ErrorLoginState(this.message);

  @override
  List<Object> get props => [message];
}
