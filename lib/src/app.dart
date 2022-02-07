import 'package:eshopee/src/models/product_model.dart';
import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/screens/about_developer/about_developer_screen.dart';
import 'package:eshopee/src/screens/cart/cart_screen.dart';
import 'package:eshopee/src/screens/category_products/category_products_screen.dart';
import 'package:eshopee/src/screens/change_display_name/change_display_name_screen.dart';
import 'package:eshopee/src/screens/forgot_password/forgot_password_screen.dart';
import 'package:eshopee/src/screens/home/home_screen.dart';
import 'package:eshopee/src/screens/sign_in/sign_in_screen.dart';
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

          initialRoute: HomeScreen.ROUTE_NAME,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            // this app enforce route args to be map<String,dynamic>? only.
            final args = routeSettings.arguments as Map<String, dynamic>? ??
                <String, dynamic>{};
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                Dimens.instance.init(context);
                switch (routeSettings.name) {
                  case SignInScreen.ROUTE_NAME:
                    return const SignInScreen();
                  case SignUpScreen.ROUTE_NAME:
                    return const SignUpScreen();
                  case ForgotPasswordScreen.ROUTE_NAME:
                    return const ForgotPasswordScreen();
                  case AboutDeveloperScreen.ROUTE_NAME:
                    return const AboutDeveloperScreen();
                  case HomeScreen.ROUTE_NAME:
                    return const HomeScreen();
                  case CartScreen.ROUTE_NAME:
                    return const CartScreen();
                  case ChangeDisplayNameScreen.ROUTE_NAME:
                    return const ChangeDisplayNameScreen();
                  case CategoryProductsScreen.ROUTE_NAME:
                    // TODO: product type arg extraction here
                    final productNameFromArgs =
                        args[CategoryProductsScreen.KEY_PRODUCT_TYPE]
                            .toString();
                    final productType =
                        productTypeFromName(productNameFromArgs);
                    if (productType == null) {
                      throw Exception(
                          "Product Type not provided to Route: ${routeSettings.name}, found null.");
                    }
                    return CategoryProductsScreen(productType: productType);

                  default:
                    // TODO: should return depending on auth
                    return const SignInScreen();
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
