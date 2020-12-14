import 'package:e_commerce_app_flutter/screens/complete_profile/complete_profile_screen.dart';
import 'package:e_commerce_app_flutter/screens/forgot_password/forgot_password_screen.dart';
import 'package:e_commerce_app_flutter/screens/login_success/login_success_screen.dart';
import 'package:e_commerce_app_flutter/screens/otp/otp_screen.dart';
import 'package:e_commerce_app_flutter/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app_flutter/screens/sign_up/sign_up_screen.dart';
import 'package:e_commerce_app_flutter/screens/splash/splash_screen.dart';
import 'package:e_commerce_app_flutter/screens/home/home_screen.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
};
