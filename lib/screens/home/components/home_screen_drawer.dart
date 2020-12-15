import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              "$appName",
              style: headingStyle.copyWith(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              "Sign out",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              context.read<AuthentificationService>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
