import 'dart:io';

import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isImageLoaded = false;
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
                "Change Display Picture",
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
          ? null
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
      return;
    }
    chosenImage = File(imagePicked.path);
    if (chosenImage == null) {
      print("Image chosen is not valid");
    } else {
      setState(() {});
    }
  }

  Widget buildActionButton() {
    return isImageLoaded
        ? DefaultButton(
            text: "Upload Picture",
            press: () {},
          )
        : DefaultButton(
            text: "Chose Picture",
            press: () {
              getImageFromUser();
            },
          );
  }
}
