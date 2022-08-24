import 'package:dazz/constants.dart';
import 'package:dazz/src/utils/dazz_localizations.dart';
import 'package:dazz/src/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DazzLocalizations localizations = DazzLocalizations.of(context);

    return Scaffold(
        backgroundColor: dPrimaryColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * .1),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
                  Container(
                    //color: Colors.red,
                    child: SvgPicture.asset(dLogo),
                    padding: EdgeInsets.only(right: size.height * .03, top: 50),
                  ),
                  Text(
                    localizations.t('global.appName'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: dInvPrimaryColor),
                  ),
                ]),
                Text(localizations.t('welcome.header'),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 40.0)),
                Text(localizations.t('welcome.subHeader'),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 26.0)),
                Container(height: size.height * .05),
                ButtonBar(
                  children: [
                    _createLoginButton(context, localizations),
                    Container(height: size.height * .03),
                    _createNewAccountButton(context, localizations),
                    Container(
                      height: size.height * .02,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _createLoginButton(BuildContext context, DazzLocalizations localizations) {
    final size = MediaQuery.of(context).size;

    return RaisedButton(
        onPressed: () {
          showLogin(context);
        },
        child: Container(
          width: size.width * .8,
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text(localizations.t('global.logIn'),
              textAlign: TextAlign.center),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 0.0,
        color: dInvPrimaryColor,
        textColor: dPrimaryColor);
  }

  _createNewAccountButton(
      BuildContext context, DazzLocalizations localizations) {
    final size = MediaQuery.of(context).size;

    return RaisedButton(
        onPressed: () {
          showSignUp(context);
        },
        child: Container(
          width: size.width * .8,
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text(
            localizations.t('global.signUp'),
            textAlign: TextAlign.center,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
              color: Colors.black, width: 2, style: BorderStyle.solid),
        ),
        elevation: 0.0,
        color: dPrimaryColor,
        textColor: dInvPrimaryColor);
  }
}
