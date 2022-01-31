import 'model.dart';

class CartItem extends Model {
  static const String KEY_PRODUCT_ID = "product_id";
  static const String KEY_ITEM_COUNT = "item_count";

  CartItem({
    Map<String, dynamic>? data,
  }) : super(data: data);

  factory CartItem.fromMap(Map<String, dynamic> map, {String? id}) {
    if (id != null) map[Model.KEY_ID] = id;
    return CartItem(
      data: map,
    );
  }

  String get productId {
    final rawVal = data[KEY_PRODUCT_ID];
    return rawVal.toString();
  }

  int get itemCount {
    final rawVal = data[KEY_ITEM_COUNT];
    if (rawVal is! int) {
      return rawVal;
    }
    return 0;
  }

  set productId(String newProductId) {
    data[KEY_PRODUCT_ID] = newProductId;
  }

  set itemCount(int newCount) {
    data[KEY_ITEM_COUNT] = newCount;
  }
}
