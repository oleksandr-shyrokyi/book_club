import 'package:book_club/screens/login/localwidgets/loginForm.dart';
import 'package:flutter/material.dart';

/// We use "Our-" prefix in order to not get confused with login of other
/// services
class OurLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                /// Logo image
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 20.0,
                  ),
                  child: Image.asset("assets/logo.png"),
                ),
                SizedBox(
                  height: 20.0,
                ),

                /// Login Form
                OurLoginForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
