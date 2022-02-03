import 'model.dart';

enum ProductType {
  Electronics,
  Books,
  Fashion,
  Groceries,
  Art,
  Others,
}

class Product extends Model {
  static const String KEY_IMAGES = "images";
  static const String KEY_TITLE = "title";
  static const String KEY_VARIANT = "variant";
  static const String KEY_DISCOUNT_PRICE = "discount_price";
  static const String KEY_ORIGINAL_PRICE = "original_price";
  static const String KEY_RATING = "rating";
  static const String KEY_HIGHLIGHTS = "highlights";
  static const String KEY_DESCRIPTION = "description";
  static const String KEY_SELLER = "seller";
  static const String KEY_OWNER = "owner";
  static const String KEY_PRODUCT_TYPE = "product_type";
  static const String KEY_SEARCH_TAGS = "search_tags";

  /*  List<String> images;
  String? title;
  String? variant;
  late num discountPrice;
  num originalPrice;
  num? rating;
  String? highlights;
  String? description;
  String? seller;
  bool? favourite;
  String? owner;
  ProductType productType;
  List<String> searchTags; */

  Product({
    Map<String, dynamic>? data,
  }) : super(data: data);

  factory Product.fromMap(Map<String, dynamic> map, {String? id}) {
    if (id != null) map[Model.KEY_ID] = id;
    if (map[KEY_SEARCH_TAGS] == null) {
      map[KEY_SEARCH_TAGS] = <String>[];
    }
    return Product(
      data: map,
    );
  }

  String get title {
    final rawVal = data[KEY_TITLE];
    return rawVal.toString();
  }

  String get description {
    final rawVal = data[KEY_DESCRIPTION];
    return rawVal.toString();
  }

  String get highlights {
    final rawVal = data[KEY_HIGHLIGHTS];
    return rawVal.toString();
  }

  String get variant {
    final rawVal = data[KEY_VARIANT];
    return rawVal.toString();
  }

  String get seller {
    final rawVal = data[KEY_SELLER];
    return rawVal.toString();
  }

  double get rating {
    final rawVal = data[KEY_RATING];
    if (rawVal is double) {
      return rawVal;
    }
    return 0.0;
  }

  set owner(String ownerUid) {
    data[KEY_OWNER] = ownerUid;
  }

  List<String> get images {
    final rawVal = data[KEY_IMAGES];
    if (rawVal is List) {
      return rawVal.cast<String>();
    }
    return <String>[];
  }

  set images(List<String> newImages) {
    data[KEY_IMAGES] = newImages;
  }

  int calculatePercentageDiscount() {
    // if discount price does not exists, then percentage discount is 0
    if (discountPrice == null) {
      return 0;
    }
    int discount =
        (((originalPrice - discountPrice!) * 100) / originalPrice).round();
    return discount;
  }

  double get originalPrice {
    final rawVal = data[KEY_ORIGINAL_PRICE].toString();
    final parsedValue = num.tryParse(rawVal);
    if (parsedValue == null) {
      throw Exception('Cannot parse Original Price from $rawVal');
    }
    return parsedValue.toDouble();
  }

  double? get discountPrice {
    final rawVal = data[KEY_DISCOUNT_PRICE];
    if (rawVal != null) {
      final parsedValue = num.tryParse(rawVal.toString());
      if (parsedValue == null) {
        throw Exception('Cannot parse Discount Price from $rawVal');
      }
      return parsedValue.toDouble();
    }
  }
}
