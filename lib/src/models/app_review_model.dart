import 'model.dart';

class AppReview extends Model {
  static const String KEY_LIKED = "liked";
  static const String KEY_FEEDBACK = "feedback";

  AppReview({Map<String, dynamic>? data}) : super(data: data);

  factory AppReview.fromMap(Map<String, dynamic> map, {String? id}) {
    if (id != null) map[Model.KEY_ID] = id;
    return AppReview(
      data: map,
    );
  }

  bool get liked {
    final rawValue = data[KEY_LIKED];
    return rawValue == true;
  }

  set liked(bool likedUpdate) {
    data[KEY_LIKED] = likedUpdate;
  }

  String get feedback {
    final rawValue = data[KEY_FEEDBACK];
    return rawValue.toString();
  }

  set feedback(String feedbackUpdate) {
    data[KEY_FEEDBACK] = feedbackUpdate;
  }
}
