import 'package:book_club/models/user.dart';
import 'package:book_club/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser extends ChangeNotifier {
  OurUser _currentUser = OurUser();

  OurUser get getCurrentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the user from Firestore
  Future<String> onStartUp() async {
    String retVal = "error";

    try {
      FirebaseUser _firebaseUser = await _auth.currentUser();
      if (_firebaseUser != null) {
        _currentUser = await OurDatabase().getUserInfo(_firebaseUser.uid);
        if(_currentUser != null) {
          retVal = "success";
        }
      }

    } catch (e) {
      print(e);
    }

    return retVal;
  }

  /// Sign out the current user
  Future<String> singOut() async {
    String retVal = "error";

    try {
      await _auth.signOut();
      // we create a new (empty) instance instead of null here because
      // if we sign in again it won't work
      _currentUser = OurUser();
      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  }

  /// Signs up a user and returns status being signed up
  Future<String> singUpUser(
      String inEmail, String inPassword, String inFullName) async {
    String retVal = "error";

    OurUser _user = OurUser();

    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: inEmail, password: inPassword);
      _user.uid = _authResult.user.uid;
      _user.email = _authResult.user.email;
      _user.fullName = inFullName;
      String _returnString = await OurDatabase().createUser(_user);
      if (_returnString == "success") {
        retVal = "success";
      }
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
      // Sends user's email and password to firebase instance sign in method
      // and gets authResult
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: inEmail, password: inPassword);

      // Stores the user id query to database info into current user instance
      _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);
      // if the current user instance isn't empty, set success
      if (_currentUser != null) {
        retVal = 'success';
      }

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

    // Creates our user instanse
    OurUser _user = OurUser();

    // Tries to sign in.
    try {
      // Sends google user email and returns google user's account
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

      // Authenticates google user's account and creates authentication instance
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;

      // Sends authentication data to google auth provider and gets
      // account credentials
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

      // Sings in with obtained credentials
      AuthResult _authResult = await _auth.signInWithCredential(credential);

      // If it's a new user the user model takes user info
      // and stores it to new database instance
      if (_authResult.additionalUserInfo.isNewUser) {
        _user.uid = _authResult.user.uid;
        _user.email = _authResult.user.email;
        _user.fullName = _authResult.user.displayName;
        OurDatabase().createUser(_user);
      }

      // Current user take user info from database instance
      // using query by user ID
      _currentUser = await OurDatabase().getUserInfo(_authResult.user.uid);

      // if current user obtains info it's succeed
      if (_currentUser != null) {
        retVal = 'success';
      }

      // if there's an error in sign in, we catch an error message and
      // assign it to retVal
    } catch (e) {
      retVal = e.message;
    }

    return retVal;
  } // loginWithGoogle()
}
