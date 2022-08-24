part of 'signup_bloc.dart';

@immutable
abstract class SignUpState extends Equatable {}

class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

//Show loading
class SignUpInState extends SignUpState {
  @override
  List<Object> get props => [];
}

class VerifyCodeSentState extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpSuccessState extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpErrorState extends SignUpState {
  final String message;

  SignUpErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DoVerificationState extends SignUpState {
  @override
  List<Object> get props => [];
}

class VerificationSuccessState extends SignUpState {
  @override
  List<Object> get props => [];
}
