import 'package:eshopee/src/services/database/user_database_helper.dart';

import 'data_streamer.dart';

class OrderedProductsStream extends DataStreamer<List<String>> {
  @override
  void reload() {
    final orderedProductsFuture = UserDatabaseHelper().orderedProductsList;
    orderedProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
