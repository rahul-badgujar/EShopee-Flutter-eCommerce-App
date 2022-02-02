import 'dart:async';

/// TfDataStreamer
///
/// This provides you with a streamer of data, which you can listen to.
/// Useful when you want to listen to the changes in certain data,
/// coming from a source e.g., API, Files, or from somewhere within the code and has probability of changes with time,
/// or requires reloading after certain events.
/// Provides useful data to alter data, filter data, add errors to the stream.
///
/// E.g., This data-streamer can be used to implement a filterable list, listen to the auth changes etc.
///
/// Note: Do not forget to dispose the TfDataStreamer after use.
abstract class DataStreamer<T> {
  // The underlying stream controller for data streamer
  late StreamController<T> _streamController;
  // Flag indicating if stream is braodcast or not.
  bool _isBroadcast = false;

  /// Initializes the data-streamer including initialization of the data.
  /// Includes call to `reload()` internally to initalize the data.
  ///
  /// Note: must be called before using any of functionality of data streamer.
  void init({bool broadcast = false}) {
    _isBroadcast = broadcast;
    if (_isBroadcast) {
      _streamController = StreamController.broadcast();
    } else {
      _streamController = StreamController();
    }
    reload();
  }

  /// Returns `true` if data-streamer is closed for listening.
  bool get isClosed {
    return _streamController.isClosed;
  }

  /// Returns `true` if data-streamer is open for listening.
  bool get isOpen {
    return !isClosed;
  }

  /// Returns `true` if the data-stream is a broadcast.
  bool get isBroadcast {
    return _isBroadcast;
  }

  /// Stream object to listen to.
  Stream<T> get stream => _streamController.stream;

  /// Add data to the data-streamer.
  void addData(T data) {
    if (isOpen) {
      _streamController.sink.add(data);
    }
  }

  /// Add error to the data-streamer.
  void addError(dynamic e) {
    if (isOpen) {
      _streamController.sink.addError(e);
    }
  }

  /// Causes a refresh of data for the data-streamer.
  ///
  /// Add your implementation of reloading the data here in this method.
  /// This method is also called on `init()` of data-streamer, to initialize data.
  void reload();

  /// Dispose the data-streamer.
  void dispose() {
    _streamController.close();
  }
}
