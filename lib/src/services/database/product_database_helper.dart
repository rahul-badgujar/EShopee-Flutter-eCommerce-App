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

  Future<List<String>> searchInProducts(String query,
      {ProductType? productType}) async {
    Query queryRef;
    if (productType == null) {
      queryRef = firestore.collection(PRODUCTS_COLLECTION_NAME);
    } else {
      final productTypeStr = EnumToString.convertToString(productType);
      queryRef = firestore
          .collection(PRODUCTS_COLLECTION_NAME)
          .where(Product.PRODUCT_TYPE_KEY, isEqualTo: productTypeStr);
    }

    final productsId = <String>{};
    final querySearchInTags = await queryRef
        .where(Product.SEARCH_TAGS_KEY, arrayContains: query)
        .get();
    for (final doc in querySearchInTags.docs) {
      productsId.add(doc.id);
    }
    final queryRefDocs = await queryRef.get();
    for (final doc in queryRefDocs.docs) {
      final docData = doc.data() ?? <String, dynamic>{};
      final product =
          Product.fromMap(docData as Map<String, dynamic>, id: doc.id);
      if (product.title.toString().toLowerCase().contains(query) ||
          product.description.toString().toLowerCase().contains(query) ||
          product.highlights.toString().toLowerCase().contains(query) ||
          product.variant.toString().toLowerCase().contains(query) ||
          product.seller.toString().toLowerCase().contains(query)) {
        final productId = product.id;
        if (productId != null) {
          productsId.add(productId);
        }
      }
    }
    return productsId.toList();
  }

  Future<void> addProductReview(String productId, Review review) async {
    final reviewesCollectionRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME);
    final reviewDocRef = reviewesCollectionRef.doc(review.reviewerUid);
    final reviewDoc = await reviewDocRef.get();
    final reviewDocData = reviewDoc.data() ?? <String, dynamic>{};
    if (!reviewDoc.exists) {
      await reviewDocRef.set(review.toMap());
      await addUsersRatingForProduct(
        productId: productId,
        rating: review.rating,
      );
    } else {
      int oldRating = 0;
      oldRating = reviewDocData[Product.RATING_KEY];
      await reviewDocRef.update(review.toUpdateMap());
      await addUsersRatingForProduct(
          productId: productId, rating: review.rating, oldRating: oldRating);
    }
  }

  Future<void> addUsersRatingForProduct(
      {required String productId, required int rating, int? oldRating}) async {
    final productDocRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    final ratingsCount =
        (await productDocRef.collection(REVIEWS_COLLECTION_NAME).get())
            .docs
            .length;
    final productDoc = await productDocRef.get();
    final productDocData = productDoc.data() ?? <String, dynamic>{};
    final prevRating = productDocData[Review.RATING_KEY];
    double newRating;
    if (oldRating == null) {
      newRating = (prevRating * (ratingsCount - 1) + rating) / ratingsCount;
    } else {
      newRating =
          (prevRating * (ratingsCount) + rating - oldRating) / ratingsCount;
    }
    final newRatingRounded = double.parse(newRating.toStringAsFixed(1));
    await productDocRef.update({Product.RATING_KEY: newRatingRounded});
  }

  Future<Review?> getProductReviewWithID(
      String productId, String reviewId) async {
    final reviewesCollectionRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME);
    final reviewDoc = await reviewesCollectionRef.doc(reviewId).get();
    final reviewDocData = reviewDoc.data() ?? <String, dynamic>{};
    if (reviewDoc.exists) {
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
      List<Review> reviews = const <Review>[];
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
    final docData = docSnapshot.data() ?? <String, dynamic>{};
    if (docSnapshot.exists) {
      return Product.fromMap(docData, id: docSnapshot.id);
    }
  }

  Future<String> addUsersProduct(Product product) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final productMap = product.toMap();
    product.owner = uid;
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = await productsCollectionReference.add(product.toMap());
    await docRef.update({
      Product.SEARCH_TAGS_KEY: FieldValue.arrayUnion(
          [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
    });
    return docRef.id;
  }

  Future<void> deleteUserProduct(String productId) async {
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    await productsCollectionReference.doc(productId).delete();
  }

  Future<String> updateUsersProduct(Product product) async {
    final productMap = product.toUpdateMap();
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = productsCollectionReference.doc(product.id);
    await docRef.update(productMap);
    await docRef.update({
      Product.SEARCH_TAGS_KEY: FieldValue.arrayUnion(
          [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
    });
    return docRef.id;
  }

  Future<List<String>> getCategoryProductsList(ProductType productType) async {
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final queryResult = await productsCollectionReference
        .where(Product.PRODUCT_TYPE_KEY,
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
        .where(Product.OWNER_KEY, isEqualTo: uid)
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
      String productId, List<String> imgUrl) async {
    final updateProduct = Product(null, images: imgUrl, originalPrice: 0.0);
    final docRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    await docRef.update(updateProduct.toUpdateMap());
  }

  String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }
}
