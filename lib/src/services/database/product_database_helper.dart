import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:eshopee/src/models/product_model.dart';
import 'package:eshopee/src/models/review_model.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';

class ProductDatabaseHelper {
  static const String PRODUCTS_COLLECTION_NAME = "products";
  static const String REVIEWS_COLLECTION_NAME = "reviews";

  ProductDatabaseHelper._privateConstructor();
  static final ProductDatabaseHelper _instance =
      ProductDatabaseHelper._privateConstructor();
  factory ProductDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore get firestore {
    return FirebaseFirestore.instance;
  }

  Future<List<String>> searchInProducts(
      {required String query, ProductType? productType}) async {
    Query queryRef;
    if (productType == null) {
      queryRef = firestore.collection(PRODUCTS_COLLECTION_NAME);
    } else {
      final productTypeStr = EnumToString.convertToString(productType);
      queryRef = firestore
          .collection(PRODUCTS_COLLECTION_NAME)
          .where(Product.KEY_PRODUCT_TYPE, isEqualTo: productTypeStr);
    }

    final productsId = <String>{};
    final querySearchInTags = await queryRef
        .where(Product.KEY_SEARCH_TAGS, arrayContains: query)
        .get();
    for (final doc in querySearchInTags.docs) {
      productsId.add(doc.id);
    }
    final queryRefDocs = await queryRef.get();
    for (final doc in queryRefDocs.docs) {
      final docData = doc.data() as Map<String, dynamic>;
      final product = Product.fromMap(docData, id: doc.id);
      if (product.title.toString().toLowerCase().contains(query) ||
          product.description.toString().toLowerCase().contains(query) ||
          product.highlights.toString().toLowerCase().contains(query) ||
          product.variant.toString().toLowerCase().contains(query) ||
          product.seller.toString().toLowerCase().contains(query)) {
        productsId.add(product.id);
      }
    }
    return productsId.toList();
  }

  Future<void> addProductReview(
      {required String productId, required Review review}) async {
    final existingReviewDocRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME)
        .doc(review.reviewerUid);
    final existingReviewDoc = await existingReviewDocRef.get();
    if (!existingReviewDoc.exists) {
      await existingReviewDocRef.set(review.toMap());
      await addUsersRatingForProduct(
        productId: productId,
        rating: review.rating,
      );
    } else {
      final existingReviewDocData = existingReviewDoc.data()!;
      final existingReview =
          Review.fromMap(existingReviewDocData, id: existingReviewDoc.id);
      await existingReviewDocRef.update(review.toMap());
      await addUsersRatingForProduct(
          productId: productId,
          rating: review.rating,
          oldRating: existingReview.rating);
    }
  }

  Future<void> addUsersRatingForProduct(
      {required String productId, required int rating, int? oldRating}) async {
    final productDocRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    final productDoc = await productDocRef.get();
    if (!productDoc.exists) {
      throw Exception('No product exists for given Product ID: $productId');
    }

    final ratingsCount =
        (await productDocRef.collection(REVIEWS_COLLECTION_NAME).get())
            .docs
            .length;
    final productDocData = productDoc.data()!;
    final product = Product.fromMap(productDocData, id: productDocRef.id);
    final prevRating = product.rating;
    late double newRating;
    if (oldRating == null) {
      newRating = (prevRating * (ratingsCount - 1) + rating) / ratingsCount;
    } else {
      newRating =
          (prevRating * (ratingsCount) + rating - oldRating) / ratingsCount;
    }
    final newRatingRounded = double.parse(newRating.toStringAsFixed(1));
    await productDocRef.update({Product.KEY_RATING: newRatingRounded});
  }

  Future<Review?> getProductReviewWithID(
      String productId, String reviewId) async {
    final reviewDocRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME)
        .doc(reviewId);
    final reviewDoc = await reviewDocRef.get();
    if (reviewDoc.exists) {
      final reviewDocData = reviewDoc.data()!;
      return Review.fromMap(reviewDocData, id: reviewDoc.id);
    }
  }

  Stream<List<Review>> getAllReviewsStreamForProductId(
      String productId) async* {
    final reviewesQuerySnapshot = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME)
        .get()
        .asStream();
    await for (final querySnapshot in reviewesQuerySnapshot) {
      final reviews = <Review>[];
      for (final reviewDoc in querySnapshot.docs) {
        Review review = Review.fromMap(reviewDoc.data(), id: reviewDoc.id);
        reviews.add(review);
      }
      yield reviews;
    }
  }

  Future<Product?> getProductWithID(String productId) async {
    final docSnapshot = await firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .get();
    if (docSnapshot.exists) {
      final docData = docSnapshot.data()!;
      return Product.fromMap(docData, id: docSnapshot.id);
    }
  }

  Future<String> addUsersProduct(Product product) async {
    final uid = AuthService().currentLoggedInUser.uid;
    product.owner = uid;
    final productData = product.toMap();
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = await productsCollectionReference.add(product.toMap());
    await docRef.update({
      Product.KEY_SEARCH_TAGS: FieldValue.arrayUnion(
        [productData[Product.KEY_PRODUCT_TYPE].toString().toLowerCase()],
      )
    });
    return docRef.id;
  }

  Future<void> deleteUserProduct(String productId) async {
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    await productsCollectionReference.doc(productId).delete();
  }

  Future<String> updateUsersProduct(Product product) async {
    final productMap = product.toMap();
    final docRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(product.id);
    await docRef.update(productMap);
    await docRef.update({
      Product.KEY_SEARCH_TAGS: FieldValue.arrayUnion(
          [productMap[Product.KEY_PRODUCT_TYPE].toString().toLowerCase()])
    });
    return docRef.id;
  }

  Future<List<String>> getCategoryProductsList(ProductType productType) async {
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final queryResult = await productsCollectionReference
        .where(Product.KEY_PRODUCT_TYPE,
            isEqualTo: EnumToString.convertToString(productType))
        .get();
    final productsId = <String>[];
    for (final product in queryResult.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId;
  }

  Future<List<String>> get usersProductsList async {
    final uid = AuthService().currentLoggedInUser.uid;
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final querySnapshot = await productsCollectionReference
        .where(Product.KEY_OWNER, isEqualTo: uid)
        .get();
    final usersProducts = <String>[];
    for (var doc in querySnapshot.docs) {
      usersProducts.add(doc.id);
    }
    return usersProducts;
  }

  Future<List<String>> get allProductsList async {
    final products = await firestore.collection(PRODUCTS_COLLECTION_NAME).get();
    final productsId = <String>[];
    for (final product in products.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId;
  }

  Future<void> updateProductsImages(
      String productId, List<String> imgUrlsList) async {
    final updateProduct = Product()..images = imgUrlsList;
    final docRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    await docRef.update(updateProduct.toMap());
  }

  String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }
}
