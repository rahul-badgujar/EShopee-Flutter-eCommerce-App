import 'package:eshopee/src/services/database/user_database_helper.dart';

import 'data_streamer.dart';

class CartItemsStream extends DataStreamer<List<String>> {
  @override
  void reload() {
    final allProductsFuture = UserDatabaseHelper().allCartItemsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
