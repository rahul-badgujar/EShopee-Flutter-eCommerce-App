import 'package:e_commerce_app_flutter/screens/splash/splash_screen.dart';
import 'package:e_commerce_app_flutter/services/shared_preferences/shared_preferences_service.dart';
import 'package:flutter/material.dart';

import 'authentification_wrapper.dart';

class IntroScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferencesService().firstRun,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          SharedPreferencesService().setKeyValue("welcome", false).then((_) {});
          return SplashScreen();
        }
        return AuthentificationWrapper();
      },
    );
  }
}
