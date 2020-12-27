import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthSignInException extends FirebaseAuthException {
  String _message;
  FirebaseAuthSignInException(this._message);
  String get message => _message;
  @override
  String toString() {
    return message;
  }
}

class FirebaseAuthUserDisabledException extends FirebaseAuthSignInException {
  FirebaseAuthUserDisabledException({String message = "This user is disabled"})
      : super(message);
}

class FirebaseAuthUserNotFoundException extends FirebaseAuthSignInException {
  FirebaseAuthUserNotFoundException({String message = "No such user found"})
      : super(message);
}

class FirebaseAuthWrongPasswordException extends FirebaseAuthSignInException {
  FirebaseAuthWrongPasswordException({String message = "Wrong password"})
      : super(message);
}

class FirebaseAuthUserNotVerifiedException extends FirebaseAuthSignInException {
  FirebaseAuthUserNotVerifiedException(
      {String message = "This user is not verified"})
      : super(message);
}

class FirebaseAuthSignInFailureUnknownReason
    extends FirebaseAuthSignInException {
  FirebaseAuthSignInFailureUnknownReason(
      {String message = "Sign in failed due to unknown reason"})
      : super(message);
}
