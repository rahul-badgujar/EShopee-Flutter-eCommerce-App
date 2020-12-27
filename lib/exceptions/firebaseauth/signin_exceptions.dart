import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSignInAuthException extends FirebaseAuthException {
  String _message;
  FirebaseSignInAuthException(this._message);
  String get message => _message;
  @override
  String toString() {
    return message;
  }
}

class FirebaseSignInAuthUserDisabledException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserDisabledException(
      {String message = "This user is disabled"})
      : super(message);
}

class FirebaseSignInAuthUserNotFoundException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotFoundException(
      {String message = "No such user found"})
      : super(message);
}

class FirebaseSignInAuthInvalidEmailException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthInvalidEmailException(
      {String message = "Email is not valid"})
      : super(message);
}

class FirebaseSignInAuthWrongPasswordException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthWrongPasswordException({String message = "Wrong password"})
      : super(message);
}

class FirebaseSignInAuthUserNotVerifiedException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotVerifiedException(
      {String message = "This user is not verified"})
      : super(message);
}

class FirebaseSignInAuthUnknownReasonFailure
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUnknownReasonFailure(
      {String message = "Sign in failed due to unknown reason"})
      : super(message);
}
