import 'package:book_club/screens/home/home.dart';
import 'package:book_club/screens/login/login.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  notLoggedIn,
  loggedIn,
}

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}


/// The empty root widget that routes user due to its auth status
/// build() method returns:
/// 1. Login screen if user is not logged in
/// 2. Home screen if use is logged in
class _OurRootState extends State<OurRoot> {

  // By default we set the auth status as notLogged in
  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() async {

    super.didChangeDependencies();

    // get the state, check the current user, set auth status based on state
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.onStartUp();
    if (_returnString == 'success') {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch(_authStatus) {

      case AuthStatus.notLoggedIn:
        retVal = OurLogin();
        break;

      case AuthStatus.loggedIn:
        retVal = HomeScreen();
        break;

      default:
        break;
    }

    return retVal;
  }
}
