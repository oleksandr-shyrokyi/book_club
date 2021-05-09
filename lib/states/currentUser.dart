import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  /// Logs user in using email/password login.
  ///
  /// Returns retVal that can be of 3 outputs:
  /// 1. "error" - when the code goes wrong
  /// 2. "success" - when log in is successful
  /// 3. e.massage -  when smth goes wrong in try-catch block
  Future<String> loginUserWithEmail(String inEmail, String inPassword) async {
    // Initial retVal value.
    String retVal = "error";


    try {
      // Loges in with email/password and assigns
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: inEmail, password: inPassword);

      // Assigns auth results to current user instance
      _uid = _authResult.user.uid;
      _email = _authResult.user.email;

      // if everything goes success
      retVal = "success";

      // if there's an error in logging in, we catch an error message and
      // assign it to retVal
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  }

  /// Logs user in using Google login.
  ///
  /// Returns retVal that can be of 3 outputs:
  /// 1. "error" - when the code goes wrong
  /// 2. "success" - when log in is successful
  /// 3. e.massage -  when smth goes wrong in try-catch block
  Future<String> loginUserWithGoogle() async {
    // Initial retVal value
    String retVal = "error";

    // Creates GoogleSignIn instance
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      // Sings you into a Google account
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

      // Create a Google account in firebase for you
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(credential);

      // Assigns auth results to current user instance
      _uid = _authResult.user.uid;
      _email = _authResult.user.email;

      // if everything goes success
      retVal = "success";

      // if there's an error in sign in, we catch an error message and
      // assign it to retVal
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  } // loginWithGoogle()
}
