import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSignUpAuthException extends FirebaseAuthException {
  String _message;
  FirebaseSignUpAuthException(this._message);
  String get message => _message;
  @override
  String toString() {
    return message;
  }
}

class FirebaseSignUpAuthEmailAlreadyInUseException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthEmailAlreadyInUseException(
      {String message = "Email already in use"})
      : super(message);
}

class FirebaseSignUpAuthInvalidEmailException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthInvalidEmailException(
      {String message = "Email is not valid"})
      : super(message);
}

class FirebaseSignUpAuthOperationNotAllowedException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthOperationNotAllowedException(
      {String message = "Sign up is restricted for this user"})
      : super(message);
}

class FirebaseSignUpAuthWeakPasswordException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthWeakPasswordException(
      {String message = "Weak password, try something better"})
      : super(message);
}

class FirebaseSignUpAuthUnknownReasonFailureException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthUnknownReasonFailureException(
      {String message = "Can't register due to unknown reason"})
      : super(message);
}
