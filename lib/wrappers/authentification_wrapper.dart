import 'package:e_commerce_app_flutter/screens/home/home_screen.dart';
import 'package:e_commerce_app_flutter/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthentificationWrapper extends StatelessWidget {
  static const String routeName = "/authentification_wrapper";
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      if (firebaseUser.emailVerified == true) {
        return HomeScreen();
      }
    }
    return SignInScreen();
  }
}
