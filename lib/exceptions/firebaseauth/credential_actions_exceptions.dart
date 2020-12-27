import 'package:e_commerce_app_flutter/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseCredentialActionAuthException
    extends MessagedFirebaseAuthException {
  FirebaseCredentialActionAuthException(
      {String message = "Instance of FirebasePasswordActionAuthException"})
      : super(message);
}

class FirebaseCredentialActionAuthUserNotFoundException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUserNotFoundException(
      {String message = "No such user exist"})
      : super(message: message);
}

class FirebaseCredentialActionAuthWeakPasswordException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthWeakPasswordException(
      {String message = "Password is weak, try something better"})
      : super(message: message);
}

class FirebaseCredentialActionAuthRequiresRecentLoginException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthRequiresRecentLoginException(
      {String message = "This action requires re-Login"})
      : super(message: message);
}

class FirebaseCredentialActionAuthUnknownReasonFailureException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUnknownReasonFailureException(
      {String message = "The action can't be performed due to unknown reason"})
      : super(message: message);
}
