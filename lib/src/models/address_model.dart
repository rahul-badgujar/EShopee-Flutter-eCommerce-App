import 'model.dart';

class Address extends Model {
  static const String KEY_TITLE = "title";
  static const String KEY_ADDRESS_LINE_1 = "address_line_1";
  static const String KEY_ADDRESS_LINE_2 = "address_line_2";
  static const String KEY_CITY = "city";
  static const String KEY_DISTRICT = "district";
  static const String KEY_STATE = "state";
  static const String KEY_LANDMARK = "landmark";
  static const String KEY_PINCODE = "pincode";
  static const String KEY_RECEIVER = "receiver";
  static const String KEY_PHONE = "phone";

  Address({
    Map<String, dynamic>? data,
  }) : super(data: data);

  factory Address.fromMap(Map<String, dynamic> map, {String? id}) {
    if (id != null) map[Model.KEY_ID] = id;
    return Address(data: map);
  }

  String get title {
    final rawValue = data[KEY_TITLE];
    return rawValue.toString();
  }

  String get addressLine1 {
    final rawValue = data[KEY_ADDRESS_LINE_1];
    return rawValue.toString();
  }

  String get addressLine2 {
    final rawValue = data[KEY_ADDRESS_LINE_2];
    return rawValue.toString();
  }

  String get city {
    final rawValue = data[KEY_CITY];
    return rawValue.toString();
  }

  String get district {
    final rawValue = data[KEY_DISTRICT];
    return rawValue.toString();
  }

  String get state {
    final rawValue = data[KEY_STATE];
    return rawValue.toString();
  }

  String get landmark {
    final rawValue = data[KEY_LANDMARK];
    return rawValue.toString();
  }

  String get pincode {
    final rawValue = data[KEY_PINCODE];
    return rawValue.toString();
  }

  String get receiver {
    final rawValue = data[KEY_RECEIVER];
    return rawValue.toString();
  }

  String get phone {
    final rawValue = data[KEY_PHONE];
    return rawValue.toString();
  }
}
