import 'package:dazz/constants.dart';
import 'package:dazz/src/blocs/login/login_bloc.dart';
import 'package:dazz/src/blocs/signup/signup_bloc.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:dazz/src/utils/validators.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  DazzLocalizations localizations;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showSignUpText = true;

  @override
  void initState() {
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localizations = DazzLocalizations.of(context);
    return Scaffold(
      body: _renderLogin(context),
    );
  }

  _renderLogin(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final separation = size.height * .03;

    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SafeArea(child: Container()),
              Container(
                margin: EdgeInsets.only(top: size.height * .14),
                width: double.infinity,
                child: Text(
                  localizations.t('login.header'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.0,
                  ),
                ),
              ),
              SeparatorWidget(height: size.height * .2),
              _createEmailField(context),
              SeparatorWidget(height: separation),
              _createPasswordField(context),
              SeparatorWidget(height: separation),
              Text(localizations.t('login.forgotAccount'),
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              SeparatorWidget(height: separation),
              _createLoginButton(context),
              SeparatorWidget(height: separation * .8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.Google,
                    mini: false,
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context)
                          .add(DoLoginGoogleEvent());
                    },
                  ),
                  SignInButton(
                    Buttons.Apple,
                    // mini: true,
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context)
                          .add(DoLoginAppleEvent());
                    },
                  )
                ],
              ),
              Spacer(),
              if (showSignUpText)
                TextButton(
                    onPressed: () {
                      showSignUp(context);
                    },
                    child: Text(localizations.t('login.createAccount'),
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: dPrimaryColor,
                            decoration: TextDecoration.underline))),
              SeparatorWidget(height: separation),
            ],
          ),
        ),
      ),
    );
  }

  _createEmailField(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .8,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: localizations.t('global.email'),
            contentPadding: EdgeInsets.only(bottom: 20.0)),
        style: TextStyle(
          fontSize: 22.0,
        ),
        validator: (value) {
          if (!validateEmail(value)) {
            return localizations.t('errorMessages.email');
          } else
            return null;
        },
      ),
    );
  }

  _createPasswordField(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .8,
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: localizations.t('global.password'),
            contentPadding: EdgeInsets.only(bottom: 20.0)),
        style: TextStyle(
          fontSize: 22.0,
        ),
        validator: (value) {
          if (value.length == 0)
            return localizations.t('errorMessages.emptyField');
          else
            return null;
        },
      ),
    );
  }

  _createLoginButton(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final loginButton = RaisedButton(
      onPressed: () {
        _validateForm();
      },
      child: Container(
        width: size.width * .8,
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child:
            Text(localizations.t('global.logIn'), textAlign: TextAlign.center),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      elevation: 0.0,
      color: dPrimaryColor,
      textColor: Colors.white,
    );

    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, state) {
        if (state is LoggedInState) {
          showSession(context);
        }

        if (state is SignUpSuccessState) {
          showSession(context);
        }

        if (state is LogginInState) {
          setState(() {
            showSignUpText = false;
          });
        } else {
          setState(() {
            showSignUpText = true;
          });
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LogginInState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ErrorLoginState) {
            return Column(children: [
              loginButton,
              Container(
                height: size.height * .02,
              ),
              Text(
                state.message,
                style: TextStyle(color: dRedColor, fontWeight: FontWeight.bold),
              )
            ]);
          } else {
            return loginButton;
          }
        },
      ),
    );
  }

  void _doLogin() {
    BlocProvider.of<LoginBloc>(context)
        .add(DoLoginEvent(_emailController.text, _passwordController.text));
  }

  _validateForm() {
    if (_formKey.currentState.validate()) {
      _doLogin();
    }
  }
}
