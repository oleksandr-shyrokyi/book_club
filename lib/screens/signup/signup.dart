import 'package:book_club/screens/signup/localwidgets/signUpForm.dart';
import 'package:flutter/material.dart';

/// We use "Our-" prefix in order to not get confused with login of other
/// services
class OurSingUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0,),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(color: Theme.of(context).secondaryHeaderColor,),
                  ],
                ),
                SizedBox(height: 40.0),
                OurSignUpForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
