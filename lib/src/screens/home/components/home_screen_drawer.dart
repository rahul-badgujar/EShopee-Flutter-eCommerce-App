import 'package:eshopee/src/components/async_progress_dialog.dart';
import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/screens/change_display_name/change_display_name_screen.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';
import 'package:eshopee/src/services/database/user_database_helper.dart';
import 'package:eshopee/src/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: Constants.appWideScrollablePhysics,
        children: [
          StreamBuilder<User?>(
              stream: AuthService().userChanges,
              builder: (context, snapshot) {
                final user = snapshot.data;
                if (user != null) {
                  final user = snapshot.data;
                  return buildUserAccountsHeader(user!);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: Icon(Icons.error),
                  );
                }
              }),
          buildEditAccountExpansionTile(context),
          ListTile(
            leading: const Icon(Icons.edit_location),
            title: const Text(
              "Manage Addresses",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              bool allowed = await AuthService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "You haven't verified your email address. This action is only allowed for verified users.",
                    positiveResponse: "Resend verification email",
                    negativeResponse: "Go back");
                if (reverify) {
                  final future =
                      AuthService().sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AsyncProgressDialog(
                        future,
                        message: const Text("Resending verification email"),
                      );
                    },
                  );
                }
                return;
              }
              // TODO: add routing
              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageAddressesScreen(),
                ),
              ); */
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_location),
            title: const Text(
              "My Orders",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              final allowed = await AuthService().currentUserVerified;
              if (!allowed) {
                final reverify = await showConfirmationDialog(context,
                    "You haven't verified your email address. This action is only allowed for verified users.",
                    positiveResponse: "Resend verification email",
                    negativeResponse: "Go back");
                if (reverify) {
                  final future =
                      AuthService().sendVerificationEmailToCurrentUser();
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AsyncProgressDialog(
                        future,
                        message: const Text("Resending verification email"),
                      );
                    },
                  );
                }
                return;
              }
              // TODO: add routing
              /*  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyOrdersScreen(),
                ),
              ); */
            },
          ),
          buildSellerExpansionTile(context),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text(
              "About Developer",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              // TODO: add routing
              /*  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutDeveloperScreen(),
                ),
              ); */
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              "Sign out",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onTap: () async {
              final confirmation =
                  await showConfirmationDialog(context, "Confirm Sign out ?");
              if (confirmation) AuthService().signOut();
            },
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsHeader(User user) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: UiPalette.textDarkShade(3).withOpacity(0.15),
      ),
      accountEmail: Text(
        user.email ?? "No Email",
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      accountName: Text(
        user.displayName ?? "No Name",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      currentAccountPicture: FutureBuilder<String?>(
        future: UserDatabaseHelper().displayPictureForCurrentUser,
        builder: (context, snapshot) {
          final displayPicUrl = snapshot.data;
          if (displayPicUrl != null) {
            return CircleAvatar(
              backgroundImage: NetworkImage(displayPicUrl),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
          }
          return CircleAvatar(
            backgroundColor: UiPalette.textDarkShade(3),
          );
        },
      ),
    );
  }

  Widget buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.person),
      title: const Text(
        "Edit Account",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      children: [
        ListTile(
          title: const Text(
            "Change Display Picture",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            // TODO: add routing
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeDisplayPictureScreen(),
                )); */
          },
        ),
        ListTile(
          title: const Text(
            "Change Display Name",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.restorablePushNamed(
                context, ChangeDisplayNameScreen.ROUTE_NAME);
          },
        ),
        ListTile(
          title: const Text(
            "Change Phone Number",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            // TODO: add routing
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePhoneScreen(),
                )); */
          },
        ),
        ListTile(
          title: const Text(
            "Change Email",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            // TODO: add routing
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeEmailScreen(),
                )); */
          },
        ),
        ListTile(
          title: const Text(
            "Change Password",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            // TODO: add routing
            /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                )); */
          },
        ),
      ],
    );
  }

  Widget buildSellerExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.business),
      title: const Text(
        "I am Seller",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      children: [
        ListTile(
          title: const Text(
            "Add New Product",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () async {
            final allowed = await AuthService().currentUserVerified;
            if (!allowed) {
              final reverify = await showConfirmationDialog(context,
                  "You haven't verified your email address. This action is only allowed for verified users.",
                  positiveResponse: "Resend verification email",
                  negativeResponse: "Go back");
              if (reverify) {
                final future =
                    AuthService().sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: const Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            // TODO: add routing
            /* Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProductScreen())); */
          },
        ),
        ListTile(
          title: const Text(
            "Manage My Products",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () async {
            final allowed = await AuthService().currentUserVerified;
            if (!allowed) {
              final reverify = await showConfirmationDialog(context,
                  "You haven't verified your email address. This action is only allowed for verified users.",
                  positiveResponse: "Resend verification email",
                  negativeResponse: "Go back");
              if (reverify) {
                final future =
                    AuthService().sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: const Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            // TODO: add routing
            /* Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyProductsScreen(),
              ),
            ); */
          },
        ),
      ],
    );
  }
}
