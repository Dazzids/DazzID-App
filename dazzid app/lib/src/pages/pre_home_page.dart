import 'package:dazz/src/pages/helper_pages/pre_credential_detail_page.dart';
import 'package:dazz/src/pages/verification_page.dart';
import 'package:dazz/src/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreHomePage extends StatefulWidget {
  @override
  _PreHomePageState createState() => _PreHomePageState();
}

class _PreHomePageState extends State<PreHomePage> {
  AuthUserState _authState;

  @override
  Widget build(BuildContext context) {
    _authState = Provider.of<AuthUserState>(context, listen: false);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Errpr'));
        }

        if (snapshot.hasData && !snapshot.data.emailVerified) {
          return VerificationPAge();
        }

        if (snapshot.hasData && snapshot.data.emailVerified) {
          return PreCredentialDetailPage();
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
