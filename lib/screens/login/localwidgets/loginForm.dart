import 'package:book_club/screens/root/root.dart';
import 'package:book_club/screens/signup/signup.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum LoginType { email, google }

class OurLoginForm extends StatefulWidget {
  @override
  _OurLoginFormState createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  /// TextEditing controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  /// ------------ Methods ----------------

  /// Logs in a user according to a login type and checks the _returnString
  /// value:
  /// 1. if it "success" - navigates to HomeScreen
  /// 2. other vice it shows snackbar with "error" or catch error message
  void loginUser(
      {@required LoginType inType,
      String inEmail,
      String inPassword,
      BuildContext inContext}) async {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try {
      // Checks login type and switches the corresponding login method.
      // Assigns login result to _returnString variable
      String _returnString;
      switch (inType) {
        case LoginType.email:
          _returnString =
              await _currentUser.loginUserWithEmail(inEmail, inPassword);
          break;

        case LoginType.google:
          _returnString = await _currentUser.loginUserWithGoogle();
          break;

        default:
      }

      // Checks the value of _returnString variable and navigates or shows
      // error snackbar
      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OurRoot()),
            (route) => false);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        ); // showSnackBar
      } // else
    } catch (e) {
      print(e);
    }
  }

  Widget _googleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        loginUser(inType: LoginType.google, inContext: context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// Google logo image.
            Image(
              image: AssetImage("assets/google_logo.png"),
              height: 25,
            ),

            /// Button text
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Sing in with Google",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            controller: _emailController,
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
            controller: _passwordController,
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
                horizontal: 80,
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
            onPressed: () {
              loginUser(
                  inType: LoginType.email,
                  inEmail: _emailController.text,
                  inPassword: _passwordController.text,
                  inContext: context);
            }, // onPressed:
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

          /// Google button
          _googleButton(),
        ],
      ),
    );
  }
}
