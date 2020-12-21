import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

const String READ_STORAGE_PERMISSION_DENIED = "Read Storage restricted";
const String INVALID_FILE_CHOSEN = "Invalid File chosen";
const String FILE_SIZE_OUT_OF_BOUNDS = "File Size out of bounds";

Future<String> choseImageFromLocalFiles(
  BuildContext context, {
  int maxSizeInKB = 1024,
  int minSizeInKB = 5,
}) async {
  final PermissionStatus photoPermissionStatus =
      await Permission.photos.request();
  if (!photoPermissionStatus.isGranted) {
    return READ_STORAGE_PERMISSION_DENIED;
  }

  final imgPicker = ImagePicker();
  final imgSource = await showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text("Chose image source"),
        actions: [
          FlatButton(
            child: Text("Camera"),
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          FlatButton(
            child: Text("Gallery"),
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      );
    },
    context: context,
  );
  if (imgSource == null) return null;
  final PickedFile imagePicked = await imgPicker.getImage(source: imgSource);
  if (imagePicked == null) {
    return INVALID_FILE_CHOSEN;
  } else {
    final fileLength = await File(imagePicked.path).length();
    if (fileLength > (maxSizeInKB * 1024) ||
        fileLength < (minSizeInKB * 1024)) {
      return FILE_SIZE_OUT_OF_BOUNDS;
    }
  }
  return imagePicked.path;
}
