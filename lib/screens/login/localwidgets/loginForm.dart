import 'package:book_club/screens/signup/signup.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';

class OurLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          /// Header "Log In".
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 8.0,
            ),
            child: Text(
              "Log In",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Email input.
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: "Email",
            ),
          ),
          SizedBox(
            height: 20.0,
          ),

          /// Password input.
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outlined),
              hintText: "Password",
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 20.0,
          ),

          /// Log in Button.
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 100,
              ),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            onPressed: () {},
          ),

          /// Sing up Button.
          FlatButton(
            child: Text("Don't have an account? Sing Up here"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurSingUp(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}