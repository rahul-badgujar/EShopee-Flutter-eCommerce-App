import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationService {
  static const String SIGN_IN_SUCCESS_MSG = "Signed In";
  static const String SIGN_UP_SUCCESS_MSG = "Signed Up";
  static const String NO_USER_FOUND = "user-not-found";
  static const String WRONG_PASSWORD = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE = "email-already-in-use";
  static const String WEAK_PASSWORD = "weak-password";

  final FirebaseAuth _firebaseAuth;

  AuthentificationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return SIGN_IN_SUCCESS_MSG;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return SIGN_UP_SUCCESS_MSG;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
