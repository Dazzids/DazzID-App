import 'package:dazz/src/pages/login_page.dart';
import 'package:dazz/src/pages/signup_page.dart';
import 'package:dazz/src/pages/welcome_page.dart';
import 'package:flutter/material.dart';

final pageRoutes = <_Route>[
  _Route('Welcome', WelcomePage()),
  _Route('Login', LoginPage()),
  _Route('SignUp', SignUpPage())
];

class _Route {
  final String title;
  final Widget page;

  _Route(this.title, this.page);
}
