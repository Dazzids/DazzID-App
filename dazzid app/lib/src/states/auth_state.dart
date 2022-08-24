import 'package:dazz/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthUserState with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel _userModel = UserModel();

  FirebaseAuth get authInstance => FirebaseAuth.instance;
  User get currentUser => _auth.currentUser;

  bool isSignedIn() {
    try {
      return _auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _handleLogin(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<User> _handleLogin(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }
}
