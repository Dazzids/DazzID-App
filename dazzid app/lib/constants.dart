import 'package:flutter/material.dart';

const dPrimaryColor = Color(0xFF011627);
const dScaffoldColor = Color(0xFFF3F3F3); // Color(0xFFFDFFFC);
const dPrimaryLightColor = Color(0xff068cf9);
const dAccentColor = Color(0xff2ec4b6);
const dRedColor = Color(0xffE71D36);
const dYellowColor = Color(0xffFF9F1C);
const dGreen = Color(0xff66DE4A);

//images and animations
const dLogoOutline = 'assets/svgs/dazz_id_logo.svg';
const dLogo = 'assets/svgs/dl.svg';
const dVerificationAnimation = 'assets/animations/pin_anim.flr';
const dEmailVerifyAnimation = 'assets/animations/email_verify.flr';
const dEmailVerifyAnimationWhite = 'assets/animations/email_verify_white.flr';
const dVerified = 'assets/animations/verified.flr';
const dQRExample = 'assets/svgs/qr_example.svg';
const dCredentialVerified = 'assets/images/verified.png';
const dCredentialNoVerified = 'assets/images/no_verified.png';
const dAvatarPlaceHolder = 'assets/images/avatar-placeholder.png';

//Credenential Colors
const cAcademicColor = Color(0xff6FA8BF);
const cSkillColor = Color(0xffEEE01C);
const cWorkColor = Color(0xffED9F3F);
const cPersonalColor = Color(0xffF24193);
const cDazzColor = Color(0xff66DE4A);

//Credential Types
const academicCredential = 'academic';
const skillCredential = 'skill';
const workCredential = 'work';
const personalCredential = 'personal';
const dazzCredential = 'dazz';

//Storage
const profileImagePath = '/profile';
const assetsPath = '/assets';
const acuerdoPath = "/acuerdo";
const terminosPath = "/terminos";

//Account Type
const googleType = "Google";
const userType = "User";
const appleType = "Apple";

//Mercado pago
const mercadoPagoPublicKey = "TEST-38d6295a-af37-4f88-b786-85e742b6dbab";
const paid = "paid";
const pending = "pending";

// //Credential Titles
// const academicCredentialTitle = 'Credencial Académica';
// const skillCredentialTitle = 'Credencial Habilidades';
// const workCredentialTitle = 'Credencial Laboral';
// const personalCredentialTitle = 'Credencial Personal';

//Custom Colors
const dInvPrimaryColor = Colors.white;

ThemeData dLightTheme = ThemeData.light().copyWith(
  primaryColor: dPrimaryColor,
  accentColor: dAccentColor,
  scaffoldBackgroundColor: dScaffoldColor,
  primaryColorLight: dPrimaryLightColor,
  textSelectionTheme: TextSelectionThemeData(cursorColor: dAccentColor),
  textTheme: ThemeData.light().textTheme.apply(
      bodyColor: dPrimaryColor, displayColor: dAccentColor, fontFamily: 'SF'),
);
