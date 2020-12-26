import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/models/Review.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:enum_to_string/enum_to_string.dart';

class ProductDatabaseHelper {
  static const String PRODUCTS_COLLECTION_NAME = "products";
  static const String REVIEWS_COLLECTOIN_NAME = "reviews";

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

  Future<bool> addProductReview(String productId, Review review) async {
    try {
      final reviewesCollectionRef = firestore
          .collection(PRODUCTS_COLLECTION_NAME)
          .doc(productId)
          .collection(REVIEWS_COLLECTOIN_NAME);
      final reviewDoc = reviewesCollectionRef.doc(review.reviewerUid);
      if ((await reviewDoc.get()).exists == false) {
        reviewDoc.set(review.toMap());
        return await addUsersRatingForProduct(
          productId,
          review.rating,
        );
      } else {
        int oldRating = 0;
        oldRating = (await reviewDoc.get()).data()[Product.RATING_KEY];
        reviewDoc.update(review.toUpdateMap());
        return await addUsersRatingForProduct(productId, review.rating,
            oldRating: oldRating);
      }
    } on Exception catch (e) {
      print(e.toString);
      return false;
    }
  }

  Future<bool> addUsersRatingForProduct(String productId, int rating,
      {int oldRating}) async {
    try {
      final productDocRef =
          firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
      final ratingsCount =
          (await productDocRef.collection(REVIEWS_COLLECTOIN_NAME).get())
              .docs
              .length;
      final productDoc = await productDocRef.get();
      final prevRating = productDoc.data()[Review.RATING_KEY];
      double newRating;
      if (oldRating == null) {
        newRating = (prevRating * (ratingsCount - 1) + rating) / ratingsCount;
      } else {
        newRating =
            (prevRating * (ratingsCount) + rating - oldRating) / ratingsCount;
      }
      final newRatingRounded = double.parse(newRating.toStringAsFixed(1));
      await productDocRef.update({Product.RATING_KEY: newRatingRounded});
      return true;
    } on Exception catch (e) {
      print(e.toString);
      return false;
    }
  }

  Future<Review> getProductReviewWithID(
      String productId, String reviewId) async {
    try {
      final reviewesCollectionRef = firestore
          .collection(PRODUCTS_COLLECTION_NAME)
          .doc(productId)
          .collection(REVIEWS_COLLECTOIN_NAME);
      final reviewDoc = await reviewesCollectionRef.doc(reviewId).get();
      if (reviewDoc.exists) {
        return Review.fromMap(reviewDoc.data(), id: reviewDoc.id);
      }
      return null;
    } on Exception catch (e) {
      print(e.toString);
      return null;
    }
  }

  Future<Product> getProductWithID(String productId) async {
    try {
      final docSnapshot = await firestore
          .collection(PRODUCTS_COLLECTION_NAME)
          .doc(productId)
          .get();

      if (docSnapshot.exists) {
        return Product.fromMap(docSnapshot.data(), id: docSnapshot.id);
      }
      return null;
    } on Exception catch (e) {
      print(e.toString);
      return null;
    }
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

  Stream<List<Product>> getCategoryProducts(ProductType productType) async* {
    try {
      final productsCollectionReference =
          firestore.collection(PRODUCTS_COLLECTION_NAME);
      final queryResult = productsCollectionReference
          .where(Product.PRODUCT_TYPE_KEY,
              isEqualTo: EnumToString.convertToString(productType))
          .get()
          .asStream();
      await for (final QuerySnapshot querySnapshot in queryResult) {
        List<Product> products = List<Product>();
        for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
          Product product = Product.fromMap(doc.data(), id: doc.id);
          products.add(product);
        }
        yield products;
      }
    } on Exception catch (e) {
      print(e.toString());
      yield null;
    }
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
