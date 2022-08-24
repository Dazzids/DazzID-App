import 'package:dazz/src/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route createRoute(Widget child) {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          child,
      //transitionDuration: Duration(seconds: 2),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: Curves.easeInOut);

        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
              .animate(curvedAnimation),
          child: child,
        );
      });
}

showWelcome(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(AuthShowWelcomeEvent());
}

showLogin(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(AuthShowLoginEvent());
}

showSignUp(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(AuthShowSignUpEvent());
}

showError(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(AuthShowErrorEvent());
}

showSession(BuildContext context) {
  //Navigator.of(context).pop();
  BlocProvider.of<AuthBloc>(context).add(AuthShowSessionEvent());
}

showAuthBio(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(AuthShowAuthEvent());
}

showVerification(BuildContext context) {
  BlocProvider.of<AuthBloc>(context).add(AuthShowVerificationEvent());
}
