import 'dart:io';

import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File chosenImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "Change Avatar",
                style: headingStyle,
              ),
              SizedBox(height: getProportionateScreenHeight(40)),
              GestureDetector(
                child: buildDisplayPictureAvatar(),
                onTap: () {
                  getImageFromUser();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(80)),
              buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDisplayPictureAvatar() {
    return CircleAvatar(
      minRadius: 30,
      maxRadius: 80,
      backgroundColor: kTextColor.withOpacity(0.15),
      backgroundImage: chosenImage == null
          ? ((AuthentificationService().currentUser.photoURL == null)
              ? null
              : NetworkImage(AuthentificationService().currentUser.photoURL))
          : MemoryImage(chosenImage.readAsBytesSync()),
    );
  }

  void getImageFromUser() async {
    final PermissionStatus photoPermissionStatus =
        await Permission.photos.request();
    if (!photoPermissionStatus.isGranted) {
      print("Permission to access photos not provided...");
      return;
    }

    final imgPicker = ImagePicker();
    final PickedFile imagePicked =
        await imgPicker.getImage(source: ImageSource.gallery);
    if (imagePicked == null) {
      print("Image picked invalid");

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Image")));
      return;
    }
    chosenImage = File(imagePicked.path);
    if (chosenImage == null) {
      print("Image chosen is not valid");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Image")));
    } else if (chosenImage.lengthSync() > (500 * 1024)) {
      chosenImage = null;
      print("Max picture size is 500kB, try another picture");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Max picture size is 500kB, try another picture")));
    } else {
      setState(() {});
    }
  }

  Widget buildActionButton() {
    return chosenImage == null
        ? DefaultButton(
            text: "Chose Picture",
            press: () {
              getImageFromUser();
            },
          )
        : DefaultButton(
            text: "Upload Picture",
            press: () {
              uploadImageToFirestorage();
            },
          );
  }

  Future<void> uploadImageToFirestorage() async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Updating Display Picture, Please wait")));
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    final String currentUserUid = AuthentificationService().currentUser.uid;
    final snapshot = await firestorageRef
        .child("user/display_picture/$currentUserUid")
        .putFile(chosenImage);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print("Image uploaded at $downloadUrl");
    setState(() {
      AuthentificationService().uploadDisplayPictureForCurrentUser(downloadUrl);
    });

    Navigator.pop(context);
  }
}
