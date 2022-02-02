import 'package:eshopee/src/models/product_model.dart';
import 'package:eshopee/src/services/database/product_database_helper.dart';

import 'data_streamer.dart';

class CategoryProductsStream extends DataStreamer<List<String>> {
  final ProductType category;

  CategoryProductsStream(this.category);
  @override
  void reload() {
    final allProductsFuture =
        ProductDatabaseHelper().getCategoryProductsList(category);
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
