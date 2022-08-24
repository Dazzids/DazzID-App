import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthShowWelcomeEvent) {
      await Future.delayed(Duration(seconds: 3));
      yield AuthWelcomeState();
    }

    if (event is AuthShowLoginEvent) {
      yield AuthLoginState();
    }

    if (event is AuthShowSignUpEvent) {
      yield AuthSignUpState();
    }

    if (event is AuthShowSessionEvent) {
      yield AuthSessionState();
    }

    if (event is AuthShowVerificationEvent) {
      yield AuthVerificationState();
    }

    if (event is AuthShowAuthEvent) {
      await Future.delayed(Duration(seconds: 3));
      yield AuthReLoginState();
    }

    if (event is AuthErrorState) {
      yield AuthErrorState();
    }
  }
}
