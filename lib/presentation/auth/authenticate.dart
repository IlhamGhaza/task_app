import 'package:flutter/material.dart';

import 'register_page.dart';
import 'reset_password_page.dart';
import 'signin_page.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  bool showResetPassword = false;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
      showResetPassword = false;
    });
  }

  void toggleResetPassword() {
    setState(() {
      showResetPassword = !showResetPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showResetPassword) {
      return ResetPasswordPage(toggleView: toggleResetPassword);
    } else if (showSignIn) {
      return SigninPage(
        toggleView: toggleView,
        toggleResetPassword: toggleResetPassword,
      );
    } else {
      return RegisterPage(toggleView: toggleView);
    }
  }
}
