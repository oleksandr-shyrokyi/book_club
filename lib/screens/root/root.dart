import 'package:book_club/screens/home/home.dart';
import 'package:book_club/screens/login/login.dart';
import 'package:book_club/screens/noGroup/noGroup.dart';
import 'package:book_club/screens/splashScreen/splashScrenn.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  unknown, // or if we restart the app and we're signed in
  notLoggedIn,
  notInGroup,
  inGroup,
}

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  /// On (re)starting the app we set the auth status as "unknown"
  /// because we haven't the user checked yet
  AuthStatus _authStatus = AuthStatus.unknown;

  /// Overriding Statefull widget life cycle method, goes after initState()
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //Initialize current user instance, obtaining info from Provider
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    // Use on startUp() method to get the user from Firebase
    String _returnString = await _currentUser.onStartUp();
    // if onStartUp is "success" we check if the current user has a groupId
    if (_returnString == 'success') {
      // if current user has a groupId, we set state as "inGroup"
      if (_currentUser.getCurrentUser.groupId != null) {
        setState(() {
          _authStatus = AuthStatus.inGroup;
        });
        // if user has no groupId, we set state as "notInGroup"
      } else {
        setState(() {
          _authStatus = AuthStatus.notInGroup;
        });
      }
      // if onStartUp is not "success" we set state as "notLoggedIn"
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (_authStatus) {
      // if we (re)start the app we have splashScreen
      case AuthStatus.unknown:
        retVal = OurSplashScreen();
        break;
      // if we don't get the user from Firebase, we have Login screen
      case AuthStatus.notLoggedIn:
        retVal = OurLogin();
        break;
      // if we logged in, but don't have a group, we have NoGroup screen
      case AuthStatus.notInGroup:
        retVal = OurNoGroup();
        break;
      // if we logged in and have a group we have a Home (inGroup) screen
      case AuthStatus.inGroup:
        retVal = HomeScreen();
        break;

      default:
        break;
    }

    return retVal;
  }
}
