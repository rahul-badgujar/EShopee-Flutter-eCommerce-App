import 'package:e_commerce_app_flutter/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseSignInAuthException extends MessagedFirebaseAuthException {
  FirebaseSignInAuthException(
      {String message: "Instance of FirebaseSignInAuthException"})
      : super(message);
}

class FirebaseSignInAuthUserDisabledException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserDisabledException(
      {String message = "This user is disabled"})
      : super(message: message);
}

class FirebaseSignInAuthUserNotFoundException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotFoundException(
      {String message = "No such user found"})
      : super(message: message);
}

class FirebaseSignInAuthInvalidEmailException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthInvalidEmailException(
      {String message = "Email is not valid"})
      : super(message: message);
}

class FirebaseSignInAuthWrongPasswordException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthWrongPasswordException({String message = "Wrong password"})
      : super(message: message);
}

class FirebaseTooManyRequestsException extends FirebaseSignInAuthException {
  FirebaseTooManyRequestsException(
      {String message = "Server busy, Please try again after some time."})
      : super(message: message);
}

class FirebaseSignInAuthUserNotVerifiedException
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotVerifiedException(
      {String message = "This user is not verified"})
      : super(message: message);
}

class FirebaseSignInAuthUnknownReasonFailure
    extends FirebaseSignInAuthException {
  FirebaseSignInAuthUnknownReasonFailure(
      {String message = "Sign in failed due to unknown reason"})
      : super(message: message);
}
