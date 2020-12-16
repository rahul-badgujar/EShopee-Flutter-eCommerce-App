import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationService {
  static const String SIGN_IN_SUCCESS_MSG = "Signed In";
  static const String SIGN_UP_SUCCESS_MSG = "Signed Up";
  static const String NO_USER_FOUND = "user-not-found";
  static const String WRONG_PASSWORD = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE = "email-already-in-use";
  static const String WEAK_PASSWORD = "weak-password";
  static const String USER_NOT_VERIFIED = "User not verified";

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

  Future<void> resetPasswordForEmail(String email) async {
    assert(email != null);
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
