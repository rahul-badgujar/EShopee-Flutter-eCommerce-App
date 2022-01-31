import 'dart:async';
import 'package:eshopee/src/services/database/user_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService _instance = AuthService._privateConstructor();

  FirebaseAuth get firebaseAuth {
    return FirebaseAuth.instance;
  }

  factory AuthService() {
    return _instance;
  }

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Stream<User?> get userChanges => firebaseAuth.userChanges();

  User? getCurrentLoggedInUserIfExists() {
    return firebaseAuth.currentUser;
  }

  /// Get current logged in user.
  ///
  /// Throws Exception if no user logged in.
  User get currentLoggedInUser {
    final loggedInUser = getCurrentLoggedInUserIfExists();
    // if no user is logged in
    if (loggedInUser == null) {
      throw Exception('No user logged in.');
    }
    return loggedInUser;
  }

  Future<void> deleteUserAccount() async {
    await currentLoggedInUser.delete();
    await signOut();
  }

  Future<void> reauthCurrentUser(password) async {
    final currentUserEmail = currentLoggedInUser.email;
    if (currentUserEmail == null) {
      throw Exception('No email exists for current logged in user');
    }
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: currentUserEmail, password: password);
    final authCredentials = userCredential.credential;
    if (authCredentials == null) {
      throw Exception(
          'Auth Credentials does not exists for current user, found null');
    }
    await currentLoggedInUser.reauthenticateWithCredential(authCredentials);
  }

  Future<void> signIn({required String email, required String password}) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final signedInUser = userCredential.user;
    if (signedInUser == null) {
      throw Exception('Failed to sign in user, user found null');
    }
    // if email is not verified, send the verification email
    if (!signedInUser.emailVerified) {
      await signedInUser.sendEmailVerification();
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final registeredUser = userCredential.user;
    if (registeredUser == null) {
      throw Exception('Failed to sign up new user.');
    }
    final uid = registeredUser.uid;
    // if email is not verified, send the verification email
    if (!registeredUser.emailVerified) {
      await registeredUser.sendEmailVerification();
    }
    await UserDatabaseHelper().createNewUser(uid);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<bool> get currentUserVerified async {
    await currentLoggedInUser.reload();
    return currentLoggedInUser.emailVerified;
  }

  Future<void> sendVerificationEmailToCurrentUser() async {
    await currentLoggedInUser.sendEmailVerification();
  }

  Future<void> updateCurrentUserDisplayName(String updatedDisplayName) async {
    await currentLoggedInUser.updateDisplayName(updatedDisplayName);
  }

  Future<void> resetPasswordForEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePasswordForCurrentUser(
      {required String oldPassword, required String newPassword}) async {
    await verifyCurrentUserPassword(oldPassword);
    await currentLoggedInUser.updatePassword(newPassword);
  }

  Future<void> changeEmailForCurrentUser(
      {required String password, required String newEmail}) async {
    await verifyCurrentUserPassword(password);
    await currentLoggedInUser.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> verifyCurrentUserPassword(String password) async {
    final currentUserEmail = currentLoggedInUser.email;
    if (currentUserEmail == null) {
      throw Exception('No email found for current user.');
    }
    final authCredential = EmailAuthProvider.credential(
      email: currentUserEmail,
      password: password,
    );
    await currentLoggedInUser.reauthenticateWithCredential(authCredential);
  }
}
