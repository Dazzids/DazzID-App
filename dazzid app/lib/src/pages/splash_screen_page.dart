import 'package:dazz/constants.dart';
import 'package:dazz/src/states/auth_state.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthUserState _authState;

  @override
  void initState() {
    _authState = Provider.of<AuthUserState>(context, listen: false);
    super.initState();

    this.checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dScaffoldColor,
      body: Stack(
        children: <Widget>[_renderIcon()],
      ),
    );
  }

  Widget _renderIcon() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size.width * 0.5,
            child: SvgPicture.asset(dLogo),
          ),
          Text(
            'Dazz ID',
            style: TextStyle(
              fontSize: 40,
              color: dPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Container(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(
                backgroundColor: dScaffoldColor,
                valueColor: new AlwaysStoppedAnimation<Color>(dPrimaryColor),
              )),
        ],
      ),
    );
  }

  void checkAuthStatus() async {
    //await Future.delayed(Duration(seconds: 3));

    try {
      if (!mounted) return;
      if (FirebaseAuth.instance.currentUser != null) {
        showAuthBio(context);
      } else {
        showWelcome(context);
      }
    } catch (e) {
      if (!mounted) return;
      print(e.toString());
      showError(context);
    }
  }
}
