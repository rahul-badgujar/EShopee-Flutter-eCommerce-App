import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/screens/sign_in/sign_in_screen.dart';
import 'package:eshopee/src/screens/sign_up/components/sign_up_form.dart';
import 'package:eshopee/src/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        PrimaryLightTheme.instance.init(context);
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          /* localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ], */

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          /* onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle, */

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: PrimaryLightTheme.instance.theme,
          // themeMode: settingsController.themeMode,

          initialRoute: SignInScreen.ROUTE_NAME,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                Dimens.instance.init(context);
                switch (routeSettings.name) {
                  case SignInScreen.ROUTE_NAME:
                    return const SignInScreen();
                  case SignUpScreen.ROUTE_NAME:
                    return const SignUpScreen();
                  default:
                    // TODO: should return depending on auth
                    return const SignUpScreen();
                }
              },
            );
          },

          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
