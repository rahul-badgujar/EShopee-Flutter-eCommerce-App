import 'model.dart';

class Review extends Model {
  static const String KEY_REVIEWER_UID = "reviewer_uid";
  static const String KEY_RATING = "rating";
  static const String KEY_FEEDBACK = "review";

  static const DEFAULT_RATING = 3;

  Review({
    Map<String, dynamic>? data,
  }) : super(data: data);

  factory Review.fromMap(Map<String, dynamic> map, {String? id}) {
    if (id != null) map[Model.KEY_ID] = id;
    return Review(
      data: map,
    );
  }

  int get rating {
    final rawVal = data[KEY_RATING];
    if (rawVal is! int) {
      return rawVal;
    }
    return DEFAULT_RATING;
  }

  String get reviewerUid {
    final rawVal = data[KEY_REVIEWER_UID];
    if (rawVal == null) {
      throw Exception('Reviewer UID found null');
    }
    return rawVal;
  }
}
