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

  Future<void> updateProductsImages(
      String productId, List<String> imgUrl) async {
    final Product updateProduct = Product(null, images: imgUrl);
    final docRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    await docRef.update(updateProduct.toUpdateMap());
  }
}
