import 'package:book_club/screens/root/root.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is home"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text(
            "Sign out",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            CurrentUser _currentUser =
                Provider.of<CurrentUser>(context, listen: false);
            String _returnString = await _currentUser.singOut();
            if (_returnString == "success") {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => OurRoot()),
                  (route) => false);
            }
          },
        ),
      ),
    );
  }
}
