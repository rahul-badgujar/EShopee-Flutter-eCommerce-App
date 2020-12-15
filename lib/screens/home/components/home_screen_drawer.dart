import 'package:e_commerce_app_flutter/screens/otp/otp_screen.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../change_display_name/change_display_name_screen.dart';

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
          ExpansionTile(
            leading: Icon(Icons.person),
            title: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            children: [
              ListTile(
                title: Text(
                  "Change Display Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeDisplayNameScreen(),
                      ));
                },
              ),
              ListTile(
                title: Text(
                  "Change Phone Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(),
                      ));
                },
              ),
              ListTile(
                title: Text(
                  "Change Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                onTap: () {},
              ),
            ],
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
