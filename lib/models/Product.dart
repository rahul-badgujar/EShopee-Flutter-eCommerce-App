import 'package:e_commerce_app_flutter/models/Model.dart';

class Product extends Model {
  static const String IMAGES_KEY = "images";
  static const String TITLE_KEY = "title";
  static const String VARIANT_KEY = "variant";
  static const String DISCOUNT_PRICE_KEY = "discount_price";
  static const String ORIGINAL_PRICE_KEY = "original_price";
  static const String RATING_KEY = "rating";
  static const String HIGHLIGHTS_KEY = "highlights";
  static const String DESCRIPTION_KEY = "description";
  static const String SELLER_KEY = "seller";
  static const String FAVOURITE_KEY = "favourite";
  static const String OWNER_KEY = "owner";

  List<String> images;
  String title;
  String variant;
  double discountPrice;
  double originalPrice;
  double rating;
  String highlights;
  String description;
  String seller;
  bool favourite;
  String owner;

  Product(
    String id, {
    this.images,
    this.title,
    this.variant,
    this.discountPrice,
    this.originalPrice,
    this.rating = 0.0,
    this.highlights,
    this.description,
    this.seller,
    this.favourite = false,
    this.owner,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      IMAGES_KEY: images,
      TITLE_KEY: title,
      VARIANT_KEY: variant,
      DISCOUNT_PRICE_KEY: discountPrice,
      ORIGINAL_PRICE_KEY: originalPrice,
      RATING_KEY: rating,
      HIGHLIGHTS_KEY: highlights,
      DESCRIPTION_KEY: description,
      SELLER_KEY: seller,
      FAVOURITE_KEY: favourite,
      OWNER_KEY: owner,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (images != null) map[IMAGES_KEY] = images;
    if (title != null) map[TITLE_KEY] = title;
    if (variant != null) map[VARIANT_KEY] = variant;
    if (discountPrice != null) map[DISCOUNT_PRICE_KEY] = discountPrice;
    if (originalPrice != null) map[ORIGINAL_PRICE_KEY] = originalPrice;
    if (rating != null) map[RATING_KEY] = rating;
    if (highlights != null) map[HIGHLIGHTS_KEY] = highlights;
    if (description != null) map[DESCRIPTION_KEY] = description;
    if (seller != null) map[SELLER_KEY] = seller;
    if (favourite != null) map[FAVOURITE_KEY] = favourite;
    if (owner != null) map[OWNER_KEY] = owner;
    return map;
  }
}
