import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dazz/constants.dart';
import 'package:dazz/src/blocs/login/login_bloc.dart';
import 'package:dazz/src/models/user.dart';
import 'package:dazz/src/pages/landing_page.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:dazz/src/widgets/separator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
// ignore: import_of_legacy_library_into_null_safe

class LocalAuthPage extends StatefulWidget {
  @override
  _LocalAuthPageState createState() => _LocalAuthPageState();
}

class _LocalAuthPageState extends State<LocalAuthPage> {
  TextEditingController _passwordController;
  DazzLocalizations localizations;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showSignUpText = true;
  //AuthUserState _authUserState;
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserService _userService = UserService();

  bool _hasBiometricSensor;
  List<BiometricType> _availableBiometrics;
  String _isAuthorized;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LocalAuthentication authentication = LocalAuthentication();

  @override
  void initState() {
    _passwordController = new TextEditingController();
    // if (mounted) {
    //   _authUserState = context.read<AuthUserState>();
    //   _authUserState = Provider.of<AuthUserState>(context, listen: false);
    // }
    _checkForBiometrics();
    _getListOfBiometric();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = DazzLocalizations.of(context);
    _isAuthorized = localizations.t('login.unAuthorized');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: StreamBuilder<DocumentSnapshot>(
              stream: _userService.getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data.data() == null) {
                  return LandingPage();
                }

                UserModel userModel = UserModel.fromSnapshot(snapshot.data);

                return Column(
                  children: [
                    SafeArea(child: Container()),
                    Container(
                      margin: EdgeInsets.only(top: size.height * .1),
                      width: double.infinity,
                      child: Text(
                        localizations.t('login.header'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36.0,
                        ),
                      ),
                    ),
                    SeparatorWidget(height: size.height * .1),
                    _createEmailField(context, userModel),
                    SeparatorWidget(height: separation),
                    displayControls(userModel, separation),
                    // if (userModel.accountType == userType)
                    //   _createPasswordField(context),
                    // SeparatorWidget(height: separation),
                    // Text(localizations.t('login.forgotAccount'),
                    //     style: TextStyle(
                    //         fontSize: 15.0, fontWeight: FontWeight.bold)),
                    // SeparatorWidget(height: separation),
                    // _createLoginButton(context),
                    SeparatorWidget(height: separation),
                    GestureDetector(
                      onTap: () => _getAuthentication(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .2,
                        child: FlareActor(
                          'assets/animations/fingerprint_blue.flr',
                          animation: "Animations",
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        ),
                      ),
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
                );
              }),
        ),
      ),
    );
  }

  _createEmailField(BuildContext context, UserModel userModel) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .8,
      margin: EdgeInsets.only(bottom: size.height * .03),
      child: Text(
        _auth.currentUser.email,
        textAlign: userModel.accountType == userType
            ? TextAlign.left
            : TextAlign.center,
        style: TextStyle(
          fontSize: 22.0,
        ),
      ),
    );
  }

  _createPasswordField(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .8,
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.emailAddress,
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
        .add(DoLoginEvent(_auth.currentUser.email, _passwordController.text));
  }

  void _bioLogin() {
    showSession(context);
  }

  _validateForm() {
    if (_formKey.currentState.validate()) {
      _doLogin();
    }
  }

  Future<void> _checkForBiometrics() async {
    bool hasBiometric;

    try {
      hasBiometric = await authentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _hasBiometricSensor = hasBiometric;
    });
  }

  Future<void> _getListOfBiometric() async {
    List<BiometricType> listOfBiometric;

    try {
      listOfBiometric = await authentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _availableBiometrics = listOfBiometric;
    });
  }

  Future<void> _getAuthentication() async {
    bool isAuthorized = false;

    try {
      isAuthorized = await authentication.authenticate(
          localizedReason: localizations.t('login.localizedReason'),
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable') {
        _showSnackbar('Huella digital no  habilitada', false);
      } else {
        _showSnackbar(e.message, false);
      }
      print(e);
    }

    if (!mounted) return;

    if (isAuthorized) {
      _bioLogin();
    }

    setState(() {
      _isAuthorized = isAuthorized
          ? localizations.t('login.authorized')
          : localizations.t('login.unAuthorized');
    });
  }

  displayControls(UserModel userModel, double separation) {
    return userModel.accountType == userType
        ? Column(
            children: [
              if (userModel.accountType == userType)
                _createPasswordField(context),
              SeparatorWidget(height: separation),
              Text(localizations.t('login.forgotAccount'),
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              SeparatorWidget(height: separation),
              _createLoginButton(context),
            ],
          )
        : Container();
  }

  _showSnackbar(String message, bool isSuccess) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ));
  }
}
