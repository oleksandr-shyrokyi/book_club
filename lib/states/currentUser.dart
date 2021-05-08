import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUser extends ChangeNotifier {
  String _uid;
  String _email;

  /// Getters for class fields
  String get getUid => _uid;
  String get getEmail => _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs up a user and returns status being signed up
  Future<String> singUpUser(String inEmail, String inPassword) async {
    String retVal = "error";

    try {
      await _auth.createUserWithEmailAndPassword(
          email: inEmail, password: inPassword);
      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  }

  /// Loges in user with his email and password. Returns status, and sets
  /// CurrentUser uid and email to AuthResult.user fields
  Future<String> loginUserWithEmail(String inEmail, String inPassword) async {
    String retVal = "error";

    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: inEmail, password: inPassword);
      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  }
}
