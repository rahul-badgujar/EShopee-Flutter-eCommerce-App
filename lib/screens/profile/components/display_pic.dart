import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DisplayPicture extends StatelessWidget {
  const DisplayPicture({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        StreamBuilder<User>(
          stream: AuthentificationService().userChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final User user = snapshot.data;
              return CircleAvatar(
                radius: 72,
                backgroundImage: NetworkImage(user.photoURL),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Icon(Icons.error),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Positioned(
          bottom: 0,
          right: -12,
          child: SizedBox(
            width: 46,
            height: 46,
            child: FlatButton(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white)),
              color: Color(0xFFF5F6F9),
              child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
