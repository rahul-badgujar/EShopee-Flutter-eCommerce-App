import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshopee/src/components/async_progress_dialog.dart';
import 'package:eshopee/src/components/default_button.dart';
import 'package:eshopee/src/resources/colors/color_palette.dart';
import 'package:eshopee/src/resources/themes/primary_light/primary_light_theme.dart';
import 'package:eshopee/src/resources/values/constants.dart';
import 'package:eshopee/src/resources/values/dimens.dart';
import 'package:eshopee/src/services/database/user_database_helper.dart';
import 'package:eshopee/src/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:eshopee/src/services/local_files_access/local_files_access_service.dart';
import 'package:eshopee/src/utils/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../provider_models/body_model.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChosenImage(),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: Constants.appWideScrollablePhysics,
          child: Padding(
            padding: Dimens.defaultScaffoldBodyPadding,
            child: SizedBox(
              width: double.infinity,
              child: Consumer<ChosenImage>(
                builder: (context, bodyState, child) {
                  return Column(
                    children: [
                      Text(
                        "Change Avatar",
                        style: PrimaryLightTheme.instance.textTheme
                            .getHeaderTextStyle(),
                      ),
                      SizedBox(
                          height: Dimens.instance.percentageScreenHeight(4)),
                      GestureDetector(
                        child: buildDisplayPictureAvatar(context, bodyState),
                        onTap: () {
                          getImageFromUser(context, bodyState);
                        },
                      ),
                      SizedBox(
                          height: Dimens.instance.percentageScreenHeight(8)),
                      buildChosePictureButton(context, bodyState),
                      SizedBox(
                          height: Dimens.instance.percentageScreenHeight(2)),
                      buildUploadPictureButton(context, bodyState),
                      SizedBox(
                          height: Dimens.instance.percentageScreenHeight(2)),
                      buildRemovePictureButton(context, bodyState),
                      SizedBox(
                          height: Dimens.instance.percentageScreenHeight(8)),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDisplayPictureAvatar(
      BuildContext context, ChosenImage bodyState) {
    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        ImageProvider? backImage;
        if (bodyState.chosenImage != null) {
          backImage = MemoryImage(bodyState.chosenImage!.readAsBytesSync());
        }
        final currentUser = snapshot.data;
        if (currentUser != null) {
          final currentUserData =
              currentUser.data() as Map? ?? <dynamic, dynamic>{};
          final url = currentUserData[UserDatabaseHelper.DP_KEY];
          if (url != null) backImage = NetworkImage(url);
        }

        if (backImage != null) {
          return CircleAvatar(
            radius: Dimens.instance.percentageScreenHeight(30),
            backgroundColor: UiPalette.primaryColor.withOpacity(0.5),
            backgroundImage: backImage,
          );
        }
        return CircleAvatar(
          radius: Dimens.instance.percentageScreenHeight(30),
          backgroundColor: UiPalette.textDarkShade(9).withOpacity(0.3),
        );
      },
    );
  }

  void getImageFromUser(BuildContext context, ChosenImage bodyState) async {
    try {
      final filePath = await choseImageFromLocalFiles(context);
      if (filePath != null) {
        bodyState.setChosenImage = File(filePath);
      }
    } catch (e) {
      showTextSnackbar(context, e.toString());
    }
  }

  Widget buildChosePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      label: "Choose Picture",
      onPressed: () async {
        getImageFromUser(context, bodyState);
      },
    );
  }

  Widget buildUploadPictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      label: "Upload Picture",
      onPressed: () async {
        final Future uploadFuture =
            uploadImageToFirestorage(context, bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
              message: const Text("Updating Display Picture"),
            );
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Display Picture updated")));
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, ChosenImage bodyState) async {
    final imageFileToUpload = bodyState.chosenImage;
    if (imageFileToUpload == null) return;

    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
        file: imageFileToUpload,
        path: UserDatabaseHelper().getPathForCurrentUserDisplayPicture(),
      );
      await UserDatabaseHelper()
          .uploadDisplayPictureForCurrentUser(downloadUrl);
      showTextSnackbar(context, "Display Picture updated successfully");
    } catch (e) {
      showTextSnackbar(context, e.toString());
    }
  }

  Widget buildRemovePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      label: "Remove Picture",
      onPressed: () async {
        final Future uploadFuture =
            removeImageFromFirestore(context, bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
              message: const Text("Deleting Display Picture"),
            );
          },
        );
        showTextSnackbar(context, '"Display Picture removed"');
        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      BuildContext context, ChosenImage bodyState) async {
    try {
      await FirestoreFilesAccess().deleteFileFromPath(
          UserDatabaseHelper().getPathForCurrentUserDisplayPicture());

      await UserDatabaseHelper().removeDisplayPictureForCurrentUser();
      showTextSnackbar(context, "Picture removed successfully");
    } catch (e) {
      showTextSnackbar(context, e.toString());
    }
  }
}
