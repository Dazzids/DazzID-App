import 'package:dazz/constants.dart';
import 'package:dazz/src/blocs/signup/signup_bloc.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:dazz/src/utils/validators.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController;
  TextEditingController _passController;
  TextEditingController _nameController;
  TextEditingController _confirmController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DazzLocalizations localizations;

  @override
  void initState() {
    _emailController = new TextEditingController();
    _passController = new TextEditingController();
    _confirmController = new TextEditingController();
    _nameController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localizations = DazzLocalizations.of(context);
    return Scaffold(
      body: _renderCreateAccountForm(context),
    );
  }

  _renderCreateAccountForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final separation = size.height * .05;

    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * .1),
      height: size.height * 1.2,
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          SafeArea(child: Container()),
          Container(
            margin: EdgeInsets.only(top: size.height * .05),
            width: double.infinity,
            child: Text(
              localizations.t('signUp.header'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34.0),
            ),
          ),
          SeparatorWidget(height: separation * 2),
          Text(
            localizations.t('signUp.subHeader'),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20.0),
          ),
          SeparatorWidget(height: separation),
          _createFullNameField(context),
          SeparatorWidget(height: separation),
          _createEmailField(context),
          SeparatorWidget(height: separation),
          _createPasswordField(context),
          SeparatorWidget(height: separation),
          _createConfirmPasswordField(context),
          SeparatorWidget(height: separation * 1.5),
          _createSignUpButton(context),
          SeparatorWidget(height: separation * .8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.Google,
                mini: false,
                onPressed: () {
                  BlocProvider.of<SignupBloc>(context)
                      .add(DoSignUpGoogleEvent());
                },
              ),
              SignInButton(
                Buttons.Apple,
                // mini: true,
                onPressed: () {
                  BlocProvider.of<SignupBloc>(context)
                      .add(DoSignUpAppleEvent());
                },
              )
            ],
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              showLogin(context);
            },
            child: Text(localizations.t('signUp.toLogin'),
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: dPrimaryColor,
                    decoration: TextDecoration.underline)),
          ),
          SeparatorWidget(height: separation * .6),
        ]),
      ),
    ));
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
        controller: _passController,
        obscureText: true,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hintText: localizations.t('global.password'),
            contentPadding: EdgeInsets.only(bottom: 20.0)),
        style: TextStyle(
          fontSize: 22.0,
        ),
      ),
    );
  }

  _createFullNameField(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .8,
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hintText: localizations.t('global.name'),
            contentPadding: EdgeInsets.only(bottom: 20.0)),
        style: TextStyle(
          fontSize: 22.0,
        ),
      ),
    );
  }

  _createConfirmPasswordField(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .8,
      child: TextFormField(
        controller: _confirmController,
        obscureText: true,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hintText: localizations.t('global.passwordConfirm'),
            contentPadding: EdgeInsets.only(bottom: 20.0)),
        style: TextStyle(
          fontSize: 22.0,
        ),
        validator: (value) {
          if (!comparePassword(_passController.text, value))
            return localizations.t('errorMessages.password');
          else
            return null;
        },
      ),
    );
  }

  _createSignUpButton(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final signUpButton = RaisedButton(
        onPressed: () {
          _validateForm();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text(
            localizations.t('global.signUp'),
            textAlign: TextAlign.center,
            style: TextStyle(color: dScaffoldColor),
          ),
          width: size.width * .8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
              width: 2, style: BorderStyle.solid, color: dPrimaryColor),
        ),
        elevation: 0.0,
        color: dPrimaryColor);

    return BlocListener<SignupBloc, SignUpState>(
      listener: (context, state) {
        if (state is VerifyCodeSentState) {
          showVerification(context);
        }

        if (state is SignUpSuccessState) {
          showSession(context);
        }
      },
      child: BlocBuilder<SignupBloc, SignUpState>(builder: (context, state) {
        if (state is SignUpInState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is SignUpErrorState) {
          return Column(children: [
            signUpButton,
            Container(
              height: size.height * .02,
            ),
            Text(
              state.message,
              style: TextStyle(color: dRedColor, fontWeight: FontWeight.bold),
            )
          ]);
        } else {
          return signUpButton;
        }
      }),
    );
  }

  void _signUp() {
    final email = _emailController.text.trim();
    final password = _passController.text.trim();
    final confirm = _confirmController.text.trim();
    final name = _nameController.text.trim();

    print('email: $email');
    print('pass: $password');
    print('confirm: $confirm');
    print('name: $name');

    BlocProvider.of<SignupBloc>(context)
        .add(DoSignUpEvent(email, password, confirm, name));
  }

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      _signUp();
    }
  }
}
