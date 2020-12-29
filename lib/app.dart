import 'package:e_commerce_app_flutter/wrappers/authentification_wrapper.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: AuthentificationWrapper()
        //home: AuthentificationWrapper(),
        );
  }
}
