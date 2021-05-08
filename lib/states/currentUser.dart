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
  Future<bool> singUpUser(String inEmail, String inPassword) async {
    bool retVal = false;

    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: inEmail, password: inPassword);
      if (_authResult.user != null) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  /// Loges in user with his email and password. Returns status, and sets
  /// CurrentUser uid and email to AuthResult.user fields
  Future<bool> loginUser(String inEmail, String inPassword) async {
    bool retVal = false;

    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: inEmail, password: inPassword);
      if (_authResult.user != null) {
        _uid = _authResult.user.uid;
        _email = _authResult.user.email;
        retVal = true;
      }
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
