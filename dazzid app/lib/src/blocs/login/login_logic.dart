import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dazz/src/blocs/login/login_bloc.dart';
import 'package:dazz/src/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../constants.dart';

abstract class LoginLogic {
  Future<LoginState> login(String email, String password);
  Future<LoginState> logout();
  Future<LoginState> signUpGoogle();
  Future<LoginState> signUpApple();
}

class LoginException implements Exception {
  final String message;

  LoginException(this.message);
}

class SimpleLoginLogic extends LoginLogic {
  @override
  Future<LoginState> login(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return LoggedInState('logueado');
      } else {
        return ErrorLoginState('error al iniciar');
      }
    } on FirebaseAuthException catch (e) {
      String error = e.message;
      throw LoginException(error);
    } catch (e) {
      throw LoginException('Error inesperado');
    }
  }

  @override
  Future<LoginState> logout() async {
    try {
      // 1
      await FirebaseAuth.instance.signOut();
      return LogOutSuccessState();
    } on Exception catch (e) {
      String error = e.toString();
      throw LoginException(error);
    }
  }

  @override
  Future<LoginState> signUpGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    UserService _userService = new UserService.UserService(); //UserService();
    await Future.delayed(Duration(seconds: 2));
    await _userService.updateDisplayNameAndType(
        userCredential.user.displayName, googleType, userCredential.user.email);

    return LoggedInState('');
  }

  @override
  Future<LoginState> signUpApple() async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
              scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
              webAuthenticationOptions: WebAuthenticationOptions(
                clientId: 'com.dazz.app.service',
                redirectUri: Uri.parse(
                  'https://us-central1-dazz-app.cloudfunctions.net/appleSignin',
                ),
              ),
              nonce: nonce);
      //nonce: nonce,

      // print(appleCredential);

      // final signInWithAppleEndpoint = Uri(
      //   scheme: 'https',
      //   host: 'flutter-sign-in-with-apple-example.glitch.me',
      //   path: '/sign_in_with_apple',
      //   queryParameters: <String, String>{
      //     'code': appleCredential.authorizationCode,
      //     if (appleCredential.givenName != null)
      //       'firstName': appleCredential.givenName,
      //     if (appleCredential.familyName != null)
      //       'lastName': appleCredential.familyName,
      //     'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
      //     if (appleCredential.state != null) 'state': appleCredential.state,
      //   },
      // );

      // final session = await http.Client().post(
      //   signInWithAppleEndpoint,
      // );

      // print(session);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}';
      final userEmail = '${appleCredential.email ?? ''}';

      final firebaseUser = authResult.user;
      print(displayName);
      if (displayName != null && displayName.trim().isNotEmpty) {
        await firebaseUser.updateProfile(displayName: displayName);
      }

      if (userEmail != null && userEmail.trim().isNotEmpty) {
        await firebaseUser.updateEmail(userEmail);
      }

      UserService _userService = new UserService();
      await Future.delayed(Duration(seconds: 2));
      await _userService.updateDisplayNameAndType(
          authResult.user.displayName, appleType, userEmail);

      return LoggedInState('');
    } on FirebaseAuthException catch (e) {
      String error = e.message;
      throw LoginException(error);
    } catch (e) {
      throw LoginException('Error inesperado');
    }
  }

  // Future<SignUpState> verifyCode(
  //     String code, String email, String password) async {
  //   try {
  //     final result = await Amplify.Auth.confirmSignUp(
  //         username: email, confirmationCode: code);

  //     if (result.isSignUpComplete) {
  //       print('login');
  //       final loginResult =
  //           await Amplify.Auth.signIn(username: email, password: password);

  //       if (loginResult.isSignedIn) {
  //         return SignUpSuccessState();
  //       } else {
  //         // 4
  //         print('User could not be signed in');
  //         return SignUpErrorState('no se pudo iniciar sesion');
  //       }
  //     } else {
  //       print('error signup');
  //       return SignUpErrorState('error sign up');
  //     }
  //   } on AuthError catch (authError) {
  //     String error = amplifyErrorParse(authError.exceptionList);
  //     print('Could not verify code - ${authError.cause}');
  //     throw SignUpException(error);
  //   } catch (e) {
  //     print(e.toString());
  //     throw SignUpException('Error inesperado');
  //   }
  // }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
