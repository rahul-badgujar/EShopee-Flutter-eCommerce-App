import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthSignUpException extends FirebaseAuthException {
  String _message;
  FirebaseAuthSignUpException(this._message);
  String get message => _message;
  @override
  String toString() {
    return message;
  }
}

class FirebaseAuthEmailAlreadyInUseException
    extends FirebaseAuthSignUpException {
  FirebaseAuthEmailAlreadyInUseException(
      {String message = "Email already in use"})
      : super(message);
}

class FirebaseAuthInvalidEmailException extends FirebaseAuthSignUpException {
  FirebaseAuthInvalidEmailException({String message = "Email is not valid"})
      : super(message);
}

class FirebaseAuthOperationNotAllowedException
    extends FirebaseAuthSignUpException {
  FirebaseAuthOperationNotAllowedException(
      {String message = "Sign up is restricted for this user"})
      : super(message);
}

class FirebaseAuthWeakPasswordException extends FirebaseAuthSignUpException {
  FirebaseAuthWeakPasswordException(
      {String message = "Weak password, try something better"})
      : super(message);
}
