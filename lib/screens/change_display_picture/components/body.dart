import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:e_commerce_app_flutter/services/local_files_access/local_files_access_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider_models/body_model.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BodyState>(
      create: (context) => BodyState(),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SizedBox(
            width: double.infinity,
            child: Consumer<BodyState>(
              builder: (context, bodyState, child) {
                return Column(
                  children: [
                    Text(
                      "Change Avatar",
                      style: headingStyle,
                    ),
                    SizedBox(height: getProportionateScreenHeight(40)),
                    GestureDetector(
                      child: buildDisplayPictureAvatar(context, bodyState),
                      onTap: () {
                        getImageFromUser(context, bodyState);
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(80)),
                    buildChosePictureButton(context, bodyState),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    buildUploadPictureButton(context, bodyState),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    buildRemovePictureButton(context, bodyState),
                    SizedBox(height: getProportionateScreenHeight(80)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDisplayPictureAvatar(BuildContext context, BodyState bodyState) {
    return StreamBuilder(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        ImageProvider backImage;
        if (bodyState.chosenImage != null) {
          backImage = MemoryImage(bodyState.chosenImage.readAsBytesSync());
        } else if (snapshot.hasData && snapshot.data != null) {
          final String url = snapshot.data.data()[UserDatabaseHelper.DP_KEY];
          backImage = NetworkImage(url);
        }
        return CircleAvatar(
          radius: SizeConfig.screenWidth * 0.3,
          backgroundColor: kTextColor.withOpacity(0.15),
          backgroundImage: backImage,
        );
      },
    );
  }

  void getImageFromUser(BuildContext context, BodyState bodyState) async {
    final path = await choseImageFromLocalFiles(context);
    if (path == null) return;
    if (path == READ_STORAGE_PERMISSION_DENIED) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Storage permissions required")));
      return;
    } else if (path == INVALID_FILE_CHOSEN) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Image")));
      return;
    } else if (path == FILE_SIZE_OUT_OF_BOUNDS) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("File size should be within 5KB to 1MB only")));
      return;
    }
    bodyState.setChosenImage = File(path);
  }

  Widget buildChosePictureButton(BuildContext context, BodyState bodyState) {
    return DefaultButton(
      text: "Choose Picture",
      press: () {
        getImageFromUser(context, bodyState);
      },
    );
  }

  Widget buildUploadPictureButton(BuildContext context, BodyState bodyState) {
    return DefaultButton(
      text: "Upload Picture",
      press: () {
        final Future uploadFuture =
            uploadImageToFirestorage(context, bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: Text("Updating Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Display Picture updated")));
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, BodyState bodyState) async {
    final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
        bodyState.chosenImage,
        UserDatabaseHelper().getPathForCurrentUserDisplayPicture());
    print("Image uploaded at $downloadUrl");

    UserDatabaseHelper().uploadDisplayPictureForCurrentUser(downloadUrl);
  }

  Widget buildRemovePictureButton(BuildContext context, BodyState bodyState) {
    return DefaultButton(
      text: "Remove Picture",
      press: () async {
        final Future uploadFuture =
            removeImageFromFirestore(context, bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              uploadFuture,
              message: Text("Deleting Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Display Picture removed")));
        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      BuildContext context, BodyState bodyState) async {
    await FirestoreFilesAccess().deleteFileFromPath(
        UserDatabaseHelper().getPathForCurrentUserDisplayPicture());
    await UserDatabaseHelper().removeDisplayPictureForCurrentUser();
  }
}
