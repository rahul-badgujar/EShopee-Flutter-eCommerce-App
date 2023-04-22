import 'dart:async';

import 'package:e_commerce_app_flutter/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:e_commerce_app_flutter/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:e_commerce_app_flutter/exceptions/firebaseauth/reauth_exceptions.dart';
import 'package:e_commerce_app_flutter/exceptions/firebaseauth/signin_exceptions.dart';
import 'package:e_commerce_app_flutter/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthentificationService {
  static const String USER_NOT_FOUND_EXCEPTION = "user-not-found";
  static const String WRONG_PASSWORD_EXCEPTION = "wrong-password";
  static const String TOO_MANY_REQUESTS_EXCEPTION = 'too-many-requests';
  static const String EMAIL_ALREADY_IN_USE_EXCEPTION = "email-already-in-use";
  static const String OPERATION_NOT_ALLOWED_EXCEPTION = "operation-not-allowed";
  static const String WEAK_PASSWORD_EXCEPTION = "weak-password";
  static const String USER_MISMATCH_EXCEPTION = "user-mismatch";
  static const String INVALID_CREDENTIALS_EXCEPTION = "invalid-credential";
  static const String INVALID_EMAIL_EXCEPTION = "invalid-email";
  static const String USER_DISABLED_EXCEPTION = "user-disabled";
  static const String INVALID_VERIFICATION_CODE_EXCEPTION =
      "invalid-verification-code";
  static const String INVALID_VERIFICATION_ID_EXCEPTION =
      "invalid-verification-id";
  static const String REQUIRES_RECENT_LOGIN_EXCEPTION = "requires-recent-login";

  FirebaseAuth _firebaseAuth;

  AuthentificationService._privateConstructor();
  static AuthentificationService _instance =
      AuthentificationService._privateConstructor();

  FirebaseAuth get firebaseAuth {
    if (_firebaseAuth == null) {
      _firebaseAuth = FirebaseAuth.instance;
    }
    return _firebaseAuth;
  }

  factory AuthentificationService() {
    return _instance;
  }

  Stream<User> get authStateChanges => firebaseAuth.authStateChanges();

  Stream<User> get userChanges => firebaseAuth.userChanges();

  Future<void> deleteUserAccount() async {
    await currentUser.delete();
    await signOut();
  }

  Future<bool> reauthCurrentUser(password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: currentUser.email, password: password);
      userCredential = await currentUser
          .reauthenticateWithCredential(userCredential.credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == WRONG_PASSWORD_EXCEPTION) {
        throw FirebaseSignInAuthWrongPasswordException();
      } else {
        throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      throw FirebaseReauthUnknownReasonFailureException(message: e.toString());
    }
    return true;
  }

  Future<bool> signIn({String email, String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.emailVerified) {
        return true;
      } else {
        await userCredential.user.sendEmailVerification();
        throw FirebaseSignInAuthUserNotVerifiedException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case INVALID_EMAIL_EXCEPTION:
          throw FirebaseSignInAuthInvalidEmailException();

        case USER_DISABLED_EXCEPTION:
          throw FirebaseSignInAuthUserDisabledException();

        case USER_NOT_FOUND_EXCEPTION:
          throw FirebaseSignInAuthUserNotFoundException();

        case WRONG_PASSWORD_EXCEPTION:
          throw FirebaseSignInAuthWrongPasswordException();

        case TOO_MANY_REQUESTS_EXCEPTION:
          throw FirebaseTooManyRequestsException();

        default:
          throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signUp({String email, String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final String uid = userCredential.user.uid;
      if (userCredential.user.emailVerified == false) {
        await userCredential.user.sendEmailVerification();
      }
      await UserDatabaseHelper().createNewUser(uid);
      return true;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case EMAIL_ALREADY_IN_USE_EXCEPTION:
          throw FirebaseSignUpAuthEmailAlreadyInUseException();
        case INVALID_EMAIL_EXCEPTION:
          throw FirebaseSignUpAuthInvalidEmailException();
        case OPERATION_NOT_ALLOWED_EXCEPTION:
          throw FirebaseSignUpAuthOperationNotAllowedException();
        case WEAK_PASSWORD_EXCEPTION:
          throw FirebaseSignUpAuthWeakPasswordException();
        default:
          throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  bool get currentUserVerified {
    currentUser.reload();
    return currentUser.emailVerified;
  }

  Future<void> sendVerificationEmailToCurrentUser() async {
    await firebaseAuth.currentUser.sendEmailVerification();
  }

  User get currentUser {
    return firebaseAuth.currentUser;
  }

  Future<void> updateCurrentUserDisplayName(String updatedDisplayName) async {
    await currentUser.updateProfile(displayName: updatedDisplayName);
  }

  Future<bool> resetPasswordForEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == USER_NOT_FOUND_EXCEPTION) {
        throw FirebaseCredentialActionAuthUserNotFoundException();
      } else {
        throw FirebaseCredentialActionAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changePasswordForCurrentUser(
      {String oldPassword, @required String newPassword}) async {
    try {
      bool isOldPasswordProvidedCorrect = true;
      if (oldPassword != null) {
        isOldPasswordProvidedCorrect =
            await verifyCurrentUserPassword(oldPassword);
      }
      if (isOldPasswordProvidedCorrect) {
        await firebaseAuth.currentUser.updatePassword(newPassword);

        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case WEAK_PASSWORD_EXCEPTION:
          throw FirebaseCredentialActionAuthWeakPasswordException();
        case REQUIRES_RECENT_LOGIN_EXCEPTION:
          throw FirebaseCredentialActionAuthRequiresRecentLoginException();
        default:
          throw FirebaseCredentialActionAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changeEmailForCurrentUser(
      {String password, String newEmail}) async {
    try {
      bool isPasswordProvidedCorrect = true;
      if (password != null) {
        isPasswordProvidedCorrect = await verifyCurrentUserPassword(password);
      }
      if (isPasswordProvidedCorrect) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);

        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw FirebaseCredentialActionAuthException(message: e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyCurrentUserPassword(String password) async {
    try {
      final AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUser.email,
        password: password,
      );

      final authCredentials =
          await currentUser.reauthenticateWithCredential(authCredential);
      return authCredentials != null;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case USER_MISMATCH_EXCEPTION:
          throw FirebaseReauthUserMismatchException();
        case USER_NOT_FOUND_EXCEPTION:
          throw FirebaseReauthUserNotFoundException();
        case INVALID_CREDENTIALS_EXCEPTION:
          throw FirebaseReauthInvalidCredentialException();
        case INVALID_EMAIL_EXCEPTION:
          throw FirebaseReauthInvalidEmailException();
        case WRONG_PASSWORD_EXCEPTION:
          throw FirebaseReauthWrongPasswordException();
        case INVALID_VERIFICATION_CODE_EXCEPTION:
          throw FirebaseReauthInvalidVerificationCodeException();
        case INVALID_VERIFICATION_ID_EXCEPTION:
          throw FirebaseReauthInvalidVerificationIdException();
        default:
          throw FirebaseReauthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }
}
