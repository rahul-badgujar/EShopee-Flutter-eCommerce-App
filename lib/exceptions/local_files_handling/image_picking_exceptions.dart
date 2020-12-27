import 'package:e_commerce_app_flutter/exceptions/local_files_handling/local_file_handling_exception.dart';

class LocalImagePickingException extends LocalFileHandlingException {
  LocalImagePickingException(
      {String message = "Instance of ImagePickingException"})
      : super(message);
}

class LocalImagePickingInvalidImageException
    extends LocalImagePickingException {
  LocalImagePickingInvalidImageException(
      {String message = "Image chosen is invalid"})
      : super(message: message);
}

class LocalImagePickingFileSizeOutOfBoundsException
    extends LocalImagePickingException {
  LocalImagePickingFileSizeOutOfBoundsException(
      {String message = "Image size not in given range"})
      : super(message: message);
}

class LocalImagePickingInvalidImageSourceException
    extends LocalImagePickingException {
  LocalImagePickingInvalidImageSourceException(
      {String message = "Image source is invalid"})
      : super(message: message);
}

class LocalImagePickingUnknownReasonFailureException
    extends LocalImagePickingException {
  LocalImagePickingUnknownReasonFailureException(
      {String message = "Failed due to unknown reason"})
      : super(message: message);
}
