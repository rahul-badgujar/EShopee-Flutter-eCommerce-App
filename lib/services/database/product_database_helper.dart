import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';

class ProductDatabaseHelper {
  static const String PRODUCTS_COLLECTION_NAME = "products";

  ProductDatabaseHelper._privateConstructor();
  static ProductDatabaseHelper _instance =
      ProductDatabaseHelper._privateConstructor();
  factory ProductDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<String> addUsersProduct(Product product) async {
    String uid = AuthentificationService().currentUser.uid;
    product.owner = uid;
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = await productsCollectionReference.add(product.toMap());
    return docRef.id;
  }

  Future<void> deleteUserProduct(String productId) async {
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    await productsCollectionReference.doc(productId).delete();
  }

  Future<String> updateUsersProduct(Product product) async {
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    await productsCollectionReference
        .doc(product.id)
        .update(product.toUpdateMap());
    return product.id;
  }

  Future<List> getUsersProductsList() async {
    String uid = AuthentificationService().currentUser.uid;

    try {
      final productsCollectionReference =
          firestore.collection(PRODUCTS_COLLECTION_NAME);
      final queryResult = await productsCollectionReference
          .where(Product.OWNER_KEY, isEqualTo: uid)
          .get();
      List<Product> products = queryResult.docs
          .map(
            (e) => Product.fromMap(
              e.data(),
              id: e.id,
            ),
          )
          .toList();

      return products;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> get usersProductListStream {
    String uid = AuthentificationService().currentUser.uid;

    try {
      final productsCollectionReference =
          firestore.collection(PRODUCTS_COLLECTION_NAME);
      final queryStream = productsCollectionReference
          .where(Product.OWNER_KEY, isEqualTo: uid)
          .get()
          .asStream();
      return queryStream;
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Product>> get allProductsListStream async* {
    try {
      final productsCollectionReference =
          firestore.collection(PRODUCTS_COLLECTION_NAME);

      final productsStream = productsCollectionReference.get().asStream();
      await for (final QuerySnapshot querySnapshot in productsStream) {
        List<Product> productsList = List<Product>();
        for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
          Product product = Product.fromMap(doc.data(), id: doc.id);
          productsList.add(product);
        }
        yield productsList;
      }
    } on Exception catch (e) {
      print(e.toString());
      yield null;
    }
  }

  Future<void> updateProductsImages(
      String productId, List<String> imgUrl) async {
    final Product updateProduct = Product(null, images: imgUrl);
    final docRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    await docRef.update(updateProduct.toUpdateMap());
  }

  String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }
}