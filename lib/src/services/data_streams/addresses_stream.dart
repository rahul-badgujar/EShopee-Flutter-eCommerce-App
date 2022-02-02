import 'package:eshopee/src/services/database/user_database_helper.dart';
import 'data_streamer.dart';

class AddressesStream extends DataStreamer<List<String>> {
  @override
  void reload() {
    final addressesList = UserDatabaseHelper().addressesList;
    addressesList.then((list) {
      addData(list);
    }).catchError((e) {
      addError(e);
    });
  }
}
