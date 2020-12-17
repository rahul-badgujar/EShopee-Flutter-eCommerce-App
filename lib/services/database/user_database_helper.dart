import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  UserDatabaseHelper._privateConstructor();
  static UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<List> getAddressesListForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    final snapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .get();
    final List<Address> addresses =
        snapshot.docs.map((e) => Address.fromMap(e.data(), id: e.id)).toList();

    return addresses;
  }
}
