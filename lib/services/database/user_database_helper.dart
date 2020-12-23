import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';

class UserDatabaseHelper {
  static const String NEW_ADDRESS_ADDED_SUCCESSFULLY =
      "New address added successfully";
  static const String ADDRESS_DELETED_SUCCESSFULLY =
      "Address deleted successfully";
  static const String ADDRESS_UPDATED_SUCCESSFULLY =
      "Address updated successfully";
  static const String PHONE_UPDATED_SUCCESSFULLY = "Phone updated successfully";

  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "display_picture";

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

  Future<void> createNewUser(String uid) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: null,
    });
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

  Future<String> addAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;

    try {
      final addressesCollectionReference = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(ADDRESSES_COLLECTION_NAME);
      await addressesCollectionReference.add(address.toMap());
      return NEW_ADDRESS_ADDED_SUCCESSFULLY;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteAddressForCurrentUser(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final addressDocReference = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(ADDRESSES_COLLECTION_NAME)
          .doc(id);
      await addressDocReference.delete();
      return ADDRESS_DELETED_SUCCESSFULLY;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> updateAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final addressDocReference = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(ADDRESSES_COLLECTION_NAME)
          .doc(address.id);
      await addressDocReference.update(address.toMap());
      return ADDRESS_UPDATED_SUCCESSFULLY;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  Stream<QuerySnapshot> get currentUserAddressesStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .snapshots();
  }

  Future<String> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDocSnapshot =
          firestore.collection(USERS_COLLECTION_NAME).doc(uid);
      await userDocSnapshot.update({PHONE_KEY: phone});
      return PHONE_UPDATED_SUCCESSFULLY;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> get currentUserPhoneNumber async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDoc =
          await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
      return await userDoc.data()[PHONE_KEY];
    } on Exception catch (_) {
      return null;
    }
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<void> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDocSnapshot =
          firestore.collection(USERS_COLLECTION_NAME).doc(uid);
      await userDocSnapshot.update({DP_KEY: url});
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeDisplayPictureForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDocSnapshot =
          firestore.collection(USERS_COLLECTION_NAME).doc(uid);
      await userDocSnapshot.update({DP_KEY: FieldValue.delete()});
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDocSnapshot =
          await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
      return userDocSnapshot.data()[DP_KEY];
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }
}
