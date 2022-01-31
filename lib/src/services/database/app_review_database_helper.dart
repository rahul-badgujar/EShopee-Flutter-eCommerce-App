import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshopee/src/models/app_review_model.dart';
import 'package:eshopee/src/services/auth/auth_service.dart';

class AppReviewDatabaseHelper {
  static const String APP_REVIEW_COLLECTION_NAME = "app_reviews";

  AppReviewDatabaseHelper._privateConstructor();
  static final AppReviewDatabaseHelper _instance =
      AppReviewDatabaseHelper._privateConstructor();
  factory AppReviewDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore get firestore {
    return FirebaseFirestore.instance;
  }

  Future<void> editAppReview(AppReview updatedAppReview) async {
    final uid = AuthService().currentLoggedInUser.uid;
    final docRef = firestore.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
    final docData = await docRef.get();
    if (docData.exists) {
      docRef.update(updatedAppReview.toMap());
    } else {
      docRef.set(updatedAppReview.toMap());
    }
  }

  Future<AppReview> getAppReviewOfCurrentUser() async {
    final uid = AuthService().currentLoggedInUser.uid;
    final docRef = firestore.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
    final doc = await docRef.get();
    final docData = doc.data()!;
    if (doc.exists) {
      final appReview = AppReview.fromMap(docData, id: doc.id);
      return appReview;
    } else {
      final appReview = AppReview()
        ..liked = true
        ..feedback = '';
      await docRef.set(appReview.toMap());
      return appReview;
    }
  }
}
