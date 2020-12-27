import 'package:firebase_auth/firebase_auth.dart';

abstract class MessagedFirebaseAuthException extends FirebaseAuthException {
  String _message;
  MessagedFirebaseAuthException(this._message);
  String get message => _message;
  @override
  String toString() {
    return message;
  }
}
