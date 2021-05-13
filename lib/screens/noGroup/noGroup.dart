import 'package:flutter/material.dart';

class OurNoGroup extends StatelessWidget {
  const OurNoGroup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Joins a already created group
    void _goToJoin() {}

    /// Crates a group
    void _goToCreate() {}

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          /// Logo Image
          Spacer(flex: 1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 80.0,
              vertical: 40.0,
            ),
            child: Image.asset("assets/logo.png"),
          ),

          /// Welcome Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Welcome to Book Club",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.grey[600],
              ),
            ),
          ),

          /// Next steps guide
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Since you are not in a book club, you can select either"
              "to join a club or create a club",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
          ),
          Spacer(flex: 1),

          /// Create and Join Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () => _goToCreate(),
                  child: Text("Create"),
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor,
                        width: 2),
                  ),
                ),
                RaisedButton(
                  onPressed: () => _goToJoin(),
                  child: Text("Join", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
