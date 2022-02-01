import 'package:flutter/material.dart';

class Constants {
  static final emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static const appWideScrollablePhysics = BouncingScrollPhysics();
}
