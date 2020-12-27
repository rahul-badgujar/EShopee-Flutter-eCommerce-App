abstract class LocalFileHandlingException {
  String _message;
  LocalFileHandlingException(this._message);
  String get message => _message;
  @override
  String toString() {
    return message;
  }
}

class LocalFileHandlingStorageReadPermissionDeniedException
    extends LocalFileHandlingException {
  LocalFileHandlingStorageReadPermissionDeniedException(
      {String message = "Storage Read permissions not granted"})
      : super(message);
}
