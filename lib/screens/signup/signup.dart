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
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: BackButton(color: Theme.of(context).secondaryHeaderColor,),
                    ),
                  ],
                ),
                SizedBox(height: 14.0),
                OurSignUpForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
