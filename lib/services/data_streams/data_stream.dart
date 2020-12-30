import 'dart:async';

abstract class DataStream<T> {
  StreamController<T> streamController;
  void init() {
    streamController = StreamController();
    reload();
  }

  Stream get stream => streamController.stream;

  void addData(T data) {
    streamController.sink.add(data);
  }

  void addError(dynamic e) {
    streamController.sink.addError(e);
  }

  void reload();

  void dispose() {
    streamController.close();
  }
}
