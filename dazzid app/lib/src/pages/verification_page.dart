import 'dart:async';

import 'package:dazz/src/states/auth_state.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class VerificationPAge extends StatefulWidget {
  @override
  _VerificationPAgeState createState() => _VerificationPAgeState();
}

class _VerificationPAgeState extends State<VerificationPAge> {
  AuthUserState _authState;
  Timer timer;
  DazzLocalizations _localizations;
  bool isVerified = false;

  @override
  void initState() {
    timer =
        Timer.periodic(Duration(seconds: 5), (timer) => _checkEmailVerified());

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _localizations = DazzLocalizations.of(context);
    if (mounted) {
      _authState = Provider.of<AuthUserState>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dScaffoldColor,
      body: Stack(
        children: <Widget>[_renderIcon(context)],
      ),
    );
  }

  Widget _renderIcon(BuildContext context) {
    //final appTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size.width * 0.5,
            child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: _animation()),
          ),
          _verifiedText(),
          Text(
            _authState.currentUser.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: dPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          )
        ],
      ),
    );
  }

  Future<void> _checkEmailVerified() async {
    await _authState.currentUser.reload();

    if (_authState.currentUser.emailVerified) {
      timer.cancel();
      setState(() {
        isVerified = true;
      });

      await Future.delayed(Duration(seconds: 4));
      showSession(context);
    }
  }

  Widget _animation() {
    return isVerified
        ? FlareActor(dVerified,
            animation: "Untitled",
            fit: BoxFit.fitHeight,
            alignment: Alignment.center)
        : FlareActor(dEmailVerifyAnimation,
            animation: "Untitled",
            fit: BoxFit.fitHeight,
            alignment: Alignment.center);
  }

  Widget _verifiedText() {
    return  isVerified
        ? Text(
            _localizations.t('verification.verified'),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18.0,
                color: dPrimaryColor,
                fontWeight: FontWeight.bold),
          )
        :        
         Text(
            _localizations.t('verification.waitEmail'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0, color: dPrimaryColor),
          )
          ;
  }
}
