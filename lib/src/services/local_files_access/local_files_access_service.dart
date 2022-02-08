import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> choseImageFromLocalFiles(
  BuildContext context, {
  int maxSizeInKB = 1024,
  int minSizeInKB = 5,
}) async {
  final photoPermissionStatus = await Permission.photos.request();
  if (!photoPermissionStatus.isGranted) {
    throw Exception(
        "Permission required to read storage, please give permission");
  }

  final imgPicker = ImagePicker();
  final imgSource = await showDialog<ImageSource?>(
    builder: (context) {
      return AlertDialog(
        title: const Text("Chose image source"),
        actions: [
          TextButton(
            child: const Text("Camera"),
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          TextButton(
            child: const Text("Gallery"),
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      );
    },
    context: context,
  );
  if (imgSource != null) {
    final imagePicked = await imgPicker.pickImage(source: imgSource);
    if (imagePicked != null) {
      final fileLength = await File(imagePicked.path).length();
      if (fileLength > (maxSizeInKB * 1024)) {
        throw Exception('Image size should not exceed $maxSizeInKB KB');
      } else if (fileLength < (minSizeInKB * 1024)) {
        throw Exception('Image size should not be less than $minSizeInKB KB');
      } else {
        return imagePicked.path;
      }
    }
  }
}
