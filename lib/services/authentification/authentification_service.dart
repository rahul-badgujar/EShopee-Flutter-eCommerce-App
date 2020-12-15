import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationService {
  static const SIGN_IN_SUCCESS_MSG = "Signed In";
  static const SIGN_UP_SUCCESS_MSG = "Signed Up";

  final FirebaseAuth _firebaseAuth;

  AuthentificationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return SIGN_IN_SUCCESS_MSG;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return SIGN_UP_SUCCESS_MSG;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
