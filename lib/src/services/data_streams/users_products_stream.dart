import 'package:eshopee/src/services/database/product_database_helper.dart';

import 'data_streamer.dart';

class UsersProductsStream extends DataStreamer<List<String>> {
  @override
  void reload() {
    final usersProductsFuture = ProductDatabaseHelper().usersProductsList;
    usersProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
