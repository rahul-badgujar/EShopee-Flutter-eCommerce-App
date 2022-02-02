import 'package:eshopee/src/services/database/user_database_helper.dart';

import 'data_streamer.dart';

class FavouriteProductsStream extends DataStreamer<List<String>> {
  @override
  void reload() {
    final favProductsFuture = UserDatabaseHelper().usersFavouriteProductsList;
    favProductsFuture.then((favProducts) {
      addData(favProducts.cast<String>());
    }).catchError((e) {
      addError(e);
    });
  }
}
