import 'package:e_commerce_app_flutter/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseReauthException extends MessagedFirebaseAuthException {
  FirebaseReauthException(
      {String message: "Instance of FirebaseReauthException"})
      : super(message);
}

class FirebaseReauthUserMismatchException extends FirebaseReauthException {
  FirebaseReauthUserMismatchException(
      {String message: "User not matching with current user"})
      : super(message: message);
}

class FirebaseReauthUserNotFoundException extends FirebaseReauthException {
  FirebaseReauthUserNotFoundException({String message = "No such user exists"})
      : super(message: message);
}

class FirebaseReauthInvalidCredentialException extends FirebaseReauthException {
  FirebaseReauthInvalidCredentialException(
      {String message = "Invalid Credentials"})
      : super(message: message);
}

class FirebaseReauthInvalidEmailException extends FirebaseReauthException {
  FirebaseReauthInvalidEmailException({String message = "Invalid Email"})
      : super(message: message);
}

class FirebaseReauthWrongPasswordException extends FirebaseReauthException {
  FirebaseReauthWrongPasswordException({String message = "Wrong password"})
      : super(message: message);
}

class FirebaseReauthInvalidVerificationCodeException
    extends FirebaseReauthException {
  FirebaseReauthInvalidVerificationCodeException(
      {String message = "Invalid Verification Code"})
      : super(message: message);
}

class FirebaseReauthInvalidVerificationIdException
    extends FirebaseReauthException {
  FirebaseReauthInvalidVerificationIdException(
      {String message = "Invalid Verification ID"})
      : super(message: message);
}

class FirebaseReauthUnknownReasonFailureException
    extends FirebaseReauthException {
  FirebaseReauthUnknownReasonFailureException(
      {String message = "Reauthentification Failed due to unknown reason"})
      : super(message: message);
}
