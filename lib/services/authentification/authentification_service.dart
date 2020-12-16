import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthentificationService {
  static const String SIGN_IN_SUCCESS_MSG = "Signed In";
  static const String SIGN_UP_SUCCESS_MSG = "Signed Up";
  static const String NO_USER_FOUND = "user-not-found";
  static const String WRONG_PASSWORD = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE = "email-already-in-use";
  static const String WEAK_PASSWORD = "weak-password";
  static const String USER_NOT_VERIFIED = "User not verified";
  static const String PASSWORD_RESET_EMAIL_SENT = "Password reset email sent";
  static const String PASSWORD_UPDATE_SUCCESSFULL =
      "Password update successfull";
  static const String USER_MISMATCH = "user-mismatch";
  static const String INVALID_CREDENTIALS = "invalid-credential";
  static const String INVALID_EMAIL = "invalid-email";

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

  Future<String> signIn({String email, String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.emailVerified) {
        return SIGN_IN_SUCCESS_MSG;
      } else {
        await userCredential.user.sendEmailVerification();
        return USER_NOT_VERIFIED;
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.emailVerified == false) {
        await userCredential.user.sendEmailVerification();
      }
      return SIGN_UP_SUCCESS_MSG;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  bool get currentUserVerified => firebaseAuth.currentUser.emailVerified;

  Future<void> sendVerificationEmailToCurrentUser() async {
    await firebaseAuth.currentUser.sendEmailVerification();
  }

  User get currentUser => firebaseAuth.currentUser;

  void updateCurrentUserDisplayName(String updatedDisplayName) {
    currentUser.updateProfile(displayName: updatedDisplayName);
  }

  Future<String> resetPasswordForEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return PASSWORD_RESET_EMAIL_SENT;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return NO_USER_FOUND;
      } else {
        return e.code;
      }
    }
  }

  Future<String> changePassword(
      {String oldPassword, @required String newPassword}) async {
    try {
      bool isOldPasswordProvidedCorrect = true;
      if (oldPassword != null) {
        isOldPasswordProvidedCorrect =
            await verifyCurrentUserPassword(oldPassword);
      }
      if (isOldPasswordProvidedCorrect) {
        await firebaseAuth.currentUser.updatePassword(newPassword);
        return PASSWORD_UPDATE_SUCCESSFULL;
      } else {
        return WRONG_PASSWORD;
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
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
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return false;
    }
  }
}
