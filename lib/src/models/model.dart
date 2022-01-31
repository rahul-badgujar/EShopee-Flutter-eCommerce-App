abstract class Model extends Object {
  static const KEY_ID = 'id';

  /// The json containing all the data for model
  late final Map<String, dynamic> data;

  Model({Map<String, dynamic>? data}) {
    this.data = data ?? <String, dynamic>{};
  }

  /// Returns the json representation of the model
  Map<String, dynamic> toMap() {
    return data;
  }

  /// Unique ID of the Model
  String get id {
    final rawId = data[KEY_ID];
    if (rawId == null) {
      throw Exception('ID found null for the model.');
    }
    return rawId.toString();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
