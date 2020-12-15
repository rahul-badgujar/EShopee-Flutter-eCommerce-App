import 'package:e_commerce_app_flutter/screens/complete_profile/complete_profile_screen.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User currentUser =
        context.watch<AuthentificationService>().currentUser;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(currentUser.email ?? "No Email"),
            accountName: Text(currentUser.displayName ?? "No Name"),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompleteProfileScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              "Sign out",
              style: TextStyle(fontSize: 16, color: Colors.black),
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
