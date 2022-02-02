import 'package:eshopee/src/services/database/product_database_helper.dart';

import 'data_streamer.dart';

class AllProductsStream extends DataStreamer<List<String>> {
  @override
  void reload() {
    final allProductsFuture = ProductDatabaseHelper().allProductsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
