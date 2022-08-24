import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bloc/bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'package:dazz/src/blocs/login/login_logic.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginLogic logic;
  LoginBloc({@required this.logic}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is DoLoginEvent) {
      yield LogginInState();

      // do login
      try {
        LoginState state = await logic.login(event.email, event.password);
        yield state;
      } on FirebaseAuthException catch (e) {
        yield ErrorLoginState(e.message);
      } catch (e) {
        yield ErrorLoginState('error inesperado');
      }
    }

    if (event is DoLoginGoogleEvent) {
      try {
        LoginState state = await logic.signUpGoogle();
        yield state;
      } catch (e) {
        yield ErrorLoginState("Error al iniciar con google");
      }
    }

    if (event is DoLoginAppleEvent) {
      try {
        LoginState state = await logic.signUpApple();
        yield state;
      } catch (e) {
        yield ErrorLoginState("Error al iniciar con apple");
      }
    }

    if (event is LogOutEvent) {
      try {
        yield DoLogOutState();
        await Future.delayed(Duration(seconds: 3));
        LoginState state = await logic.logout();
        yield state;
      } catch (e) {
        yield ErrorLoginState('Error de prueba');
      }
    }
  }
}
