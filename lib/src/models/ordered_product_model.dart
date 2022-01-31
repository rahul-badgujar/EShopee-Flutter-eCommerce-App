import 'model.dart';

class OrderedProduct extends Model {
  static const String KEY_PRODUCT_UID = "product_uid";
  static const String KEY_ORDER_DATE = "order_date";

  OrderedProduct({
    Map<String, dynamic>? data,
  }) : super(data: data);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String? id}) {
    if (id != null) map[Model.KEY_ID] = id;
    return OrderedProduct(
      data: map,
    );
  }
}
