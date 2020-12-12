import 'package:e_commerce_app_flutter/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:e_commerce_app_flutter/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      home: SplashScreen(),
    );
  }
}
