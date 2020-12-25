import 'package:e_commerce_app_flutter/models/Model.dart';

class Cart extends Model {
  static const String PRODUCT_ID_KEY = "product_id";
  static const String ITEM_COUNT_KEY = "item_count";

  String productID;
  int itemCount;
  Cart({
    String id,
    this.itemCount = 0,
    this.productID,
  }) : super(id);

  factory Cart.fromMap(Map<String, dynamic> map, {String id}) {
    return Cart(
      id: id,
      productID: map[PRODUCT_ID_KEY],
      itemCount: map[ITEM_COUNT_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCT_ID_KEY: productID,
      ITEM_COUNT_KEY: itemCount,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productID != null) map[PRODUCT_ID_KEY] = productID;
    if (itemCount != null) map[ITEM_COUNT_KEY] = itemCount;
    return map;
  }
}
