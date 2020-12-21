import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreFilesAccess {
  FirestoreFilesAccess._privateConstructor();
  static FirestoreFilesAccess _instance =
      FirestoreFilesAccess._privateConstructor();
  factory FirestoreFilesAccess() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<String> uploadFileToPath(File file, String path) async {
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    final snapshot = await firestorageRef.child(path).putFile(file);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteFileFromPath(String path) async {
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    await firestorageRef.child(path).delete();
  }
}
