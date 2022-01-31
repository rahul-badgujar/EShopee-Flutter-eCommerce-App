import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshopee/src/models/address_model.dart';
import 'package:eshopee/src/models/cart_item_model.dart';
import 'package:eshopee/src/models/ordered_product_model.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';

import 'product_database_helper.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";

  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "display_picture";
  static const String FAV_PRODUCTS_KEY = "favourite_products";

  UserDatabaseHelper._privateConstructor();
  static final UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();

  factory UserDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore get firestore {
    return FirebaseFirestore.instance;
  }

  Future<void> createNewUser(String uid) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: null,
      FAV_PRODUCTS_KEY: <String>[],
    });
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthService().currentLoggedInUser.uid;
    final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
    final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
    final ordersCollectionRef =
        docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);

    final cartDocs = await cartCollectionRef.get();
    for (final cartDoc in cartDocs.docs) {
      await cartCollectionRef.doc(cartDoc.id).delete();
    }
    final addressesDocs = await addressCollectionRef.get();
    for (final addressDoc in addressesDocs.docs) {
      await addressCollectionRef.doc(addressDoc.id).delete();
    }
    final ordersDoc = await ordersCollectionRef.get();
    for (final orderDoc in ordersDoc.docs) {
      await ordersCollectionRef.doc(orderDoc.id).delete();
    }

    await docRef.delete();
  }

  Future<bool> isProductFavourite(String productId) async {
    String uid = AuthService().currentLoggedInUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDoc = await userDocSnapshot.get();
    final userDocData = userDoc.data() ?? <String, dynamic>{};
    final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
    if (favList.contains(productId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List> get usersFavouriteProductsList async {
    String uid = AuthService().currentLoggedInUser.uid;
    final userDoc =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    final userDocData = userDoc.data() ?? <String, dynamic>{};
    final favList = userDocData[FAV_PRODUCTS_KEY] ?? [];
    return favList;
  }

  Future<void> switchProductFavouriteStatus(
      String productId, bool newState) async {
    String uid = AuthService().currentLoggedInUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);

    if (newState == true) {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
      });
    } else {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
      });
    }
  }

  Future<List<String>> get addressesList async {
    final uid = AuthService().currentLoggedInUser.uid;
    final snapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .get();
    final addresses = <String>[];
    for (final doc in snapshot.docs) {
      addresses.add(doc.id);
    }

    return addresses;
  }

  Future<Address> getAddressFromId(String id) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final doc = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id)
        .get();
    final docData = doc.data() ?? <String, dynamic>{};
    final address = Address.fromMap(docData, id: doc.id);
    return address;
  }

  Future<void> addAddressForCurrentUser(Address address) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final addressesCollectionReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
  }

  Future<void> deleteAddressForCurrentUser(String id) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(id);
    await addressDocReference.delete();
  }

  Future<void> updateAddressForCurrentUser(Address address) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final addressDocReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .doc(address.id);
    await addressDocReference.update(address.toMap());
  }

  Future<CartItem?> getCartItemFromId(String id) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final docRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .doc(id);
    final doc = await docRef.get();
    final docExists = doc.exists;

    if (docExists) {
      final docData = doc.data() ?? <String, dynamic>{};
      final cartItem = CartItem.fromMap(docData, id: doc.id);
      return cartItem;
    }
  }

  Future<void> addProductToCart(String productId) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(productId);
    final doc = await docRef.get();
    bool alreadyPresent = doc.exists;
    if (alreadyPresent == false) {
      docRef.set(CartItem(itemCount: 1).toMap());
    } else {
      docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
    }
  }

  Future<List<String>> emptyCart() async {
    final uid = AuthService().currentLoggedInUser.uid;
    final cartItems = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    final orderedProductsUid = <String>[];
    for (final doc in cartItems.docs) {
      orderedProductsUid.add(doc.id);
      await doc.reference.delete();
    }
    return orderedProductsUid;
  }

  Future<double> get cartTotal async {
    final uid = AuthService().currentLoggedInUser.uid;
    final cartItems = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    double total = 0.0;
    for (final doc in cartItems.docs) {
      final docData = doc.data();
      final itemsCount = docData[CartItem.ITEM_COUNT_KEY];
      final product = await ProductDatabaseHelper().getProductWithID(doc.id);
      if (product != null) {
        total += (itemsCount * product.discountPrice);
      }
    }
    return total;
  }

  Future<void> removeProductFromCart(String cartItemID) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final cartCollectionReference = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    await cartCollectionReference.doc(cartItemID).delete();
  }

  Future<void> increaseCartItemCount(String cartItemID) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
  }

  Future<void> decreaseCartItemCount(String cartItemID) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final cartCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    final docSnapshot = await docRef.get();
    final docData = docSnapshot.data() ?? <String, dynamic>{};
    final currentCount = docData[CartItem.ITEM_COUNT_KEY];
    if (currentCount <= 1) {
      await removeProductFromCart(cartItemID);
    } else {
      await docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(-1)});
    }
  }

  Future<List<String>> get allCartItemsList async {
    final uid = AuthService().currentLoggedInUser.uid;
    final querySnapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME)
        .get();
    final itemsId = <String>[];
    for (final item in querySnapshot.docs) {
      itemsId.add(item.id);
    }
    return itemsId;
  }

  Future<List<String>> get orderedProductsList async {
    final uid = AuthService().currentLoggedInUser.uid;
    final orderedProductsSnapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
        .get();
    final orderedProductsId = <String>[];
    for (final doc in orderedProductsSnapshot.docs) {
      orderedProductsId.add(doc.id);
    }
    return orderedProductsId;
  }

  Future<void> addToMyOrders(List<OrderedProduct> orders) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final orderedProductsCollectionRef = firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME);
    for (final order in orders) {
      await orderedProductsCollectionRef.add(order.toMap());
    }
  }

  Future<OrderedProduct> getOrderedProductFromId(String id) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final doc = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
        .doc(id)
        .get();
    final docData = doc.data() ?? <String, dynamic>{};
    final orderedProduct = OrderedProduct.fromMap(docData, id: doc.id);
    return orderedProduct;
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    final uid = AuthService().currentLoggedInUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  Future<void> updatePhoneForCurrentUser(String phone) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
  }

  String getPathForCurrentUserDisplayPicture() {
    final currentUserUid = AuthService().currentLoggedInUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<void> uploadDisplayPictureForCurrentUser(String url) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {DP_KEY: url},
    );
  }

  Future<void> removeDisplayPictureForCurrentUser() async {
    final uid = AuthService().currentLoggedInUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
  }

  Future<String?> get displayPictureForCurrentUser async {
    final uid = AuthService().currentLoggedInUser.uid;
    final userDocSnapshot =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    final userData = userDocSnapshot.data() ?? <String, dynamic>{};
    return userData[DP_KEY];
  }
}
