import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/models/CartItem.dart';
import 'package:e_commerce_app_flutter/models/OrderedProduct.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';

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
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";

  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "display_picture";
  static const String FAV_PRODUCTS_KEY = "favourite_products";

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

  Future<bool> addOrderedProduct(OrderedProduct orderedProduct) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final orderedProductsCollectionRef = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(ORDERED_PRODUCTS_COLLECTION_NAME);
      await orderedProductsCollectionRef.add(orderedProduct.toMap());
      return true;
    } on Exception catch (e) {
      print(e.toString);
      return false;
    }
  }

  Stream<List<OrderedProduct>> get orderedProductsStream async* {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final querySnapshotStream = await firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
          .get()
          .asStream();
      await for (final querySnapshot in querySnapshotStream) {
        List<OrderedProduct> orderedProductsList = List<OrderedProduct>();
        for (final doc in querySnapshot.docs) {
          final orderedProduct = OrderedProduct.fromMap(doc.data(), id: doc.id);
          orderedProductsList.add(orderedProduct);
        }
        yield orderedProductsList;
      }
    } on Exception catch (e) {
      print(e.toString);
      yield null;
    }
  }

  Future<void> createNewUser(String uid) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: null,
      FAV_PRODUCTS_KEY: List<String>(),
    });
  }

  Future<bool> isProductFavourite(String productId) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDocSnapshot =
          firestore.collection(USERS_COLLECTION_NAME).doc(uid);
      final userDocData = (await userDocSnapshot.get()).data();
      final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
      if (favList.contains(productId)) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<String>> get usersFavouriteProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDocSnapshot =
          firestore.collection(USERS_COLLECTION_NAME).doc(uid);
      final userDocData = (await userDocSnapshot.get()).data();
      final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
      return favList;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Product>> get usersFavouriteProductsStream async* {
    final usersFavProducts = await usersFavouriteProductsList;
    try {
      await for (final List<Product> list
          in ProductDatabaseHelper().allProductsListStream) {
        List<Product> favProducts = List<Product>();
        for (final Product product in list) {
          if (usersFavProducts.contains(product.id)) {
            favProducts.add(product);
          }
        }
        yield favProducts;
      }
    } catch (e) {
      print(e.toString());
      yield null;
    }
  }

  Future<void> switchProductFavouriteStatus(String productId) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final userDocSnapshot =
          firestore.collection(USERS_COLLECTION_NAME).doc(uid);
      final userDocData = (await userDocSnapshot.get()).data();
      final listPresent = userDocData.containsKey(FAV_PRODUCTS_KEY);

      if (listPresent == false) {
        List<String> fv = List<String>();
        fv.add(productId);
        userDocSnapshot.update({FAV_PRODUCTS_KEY: fv});
      } else {
        final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
        if (favList.contains(productId)) {
          userDocSnapshot.update({
            FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
          });
        } else {
          userDocSnapshot.update({
            FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
          });
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
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

  Future<bool> addProductToCart(CartItem cartItem) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final cartCollectionReference = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(CART_COLLECTION_NAME);
      await cartCollectionReference.add(cartItem.toMap());
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> removeProductFromCart(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final cartCollectionReference = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(CART_COLLECTION_NAME);
      await cartCollectionReference.doc(cartItemID).delete();
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  Stream<List<CartItem>> get allCartItemsStream async* {
    String uid = AuthentificationService().currentUser.uid;
    try {
      final querySnapshotStream = firestore
          .collection(USERS_COLLECTION_NAME)
          .doc(uid)
          .collection(CART_COLLECTION_NAME)
          .get()
          .asStream();
      await for (final QuerySnapshot querySnapshot in querySnapshotStream) {
        List<CartItem> cartItems = List<CartItem>();
        for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
          CartItem cartItem = CartItem.fromMap(doc.data(), id: doc.id);
          cartItems.add(cartItem);
        }
        yield cartItems;
      }
    } on Exception catch (e) {
      print(e.toString());
      yield null;
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
