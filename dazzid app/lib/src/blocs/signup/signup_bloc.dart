import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dazz/src/blocs/signup/signup_logic.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpLogic awsLogic;
  SignupBloc({@required this.awsLogic}) : super(SignUpInitial());

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    yield SignUpInState();

    if (event is DoSignUpEvent) {
      try {
        final resultState =
            await awsLogic.signUp(event.email, event.password, event.name);
        yield resultState;
      } on SignUpException catch (e) {
        yield SignUpErrorState(e.message);
      }
    }

    if (event is DoVerificationEvent) {
      yield DoVerificationState();

      try {
        final resultState = await awsLogic.verifyCode();
        yield resultState;
      } on SignUpException catch (e) {
        yield SignUpErrorState(e.message);
      }
    }

    if (event is DoSignUpGoogleEvent) {
      try {
        final state = await awsLogic.signUpGoogle();
        yield state;
      } on SignUpException catch (e) {
        yield SignUpErrorState(e.message);
      }
    }

    if (event is DoSignUpAppleEvent) {
      try {
        final state = await awsLogic.signUpApple();
        yield state;
      } on SignUpException catch (e) {
        yield SignUpErrorState(e.message);
      }
    }
  }
}
