import 'package:book_club/screens/noGroup/noGroup.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

var log = Logger();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    /// Gets current user, takes the groupId and updates current group due to the groupId
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    log.d(
        "HomeScreenState.initState(): _currentUser <= ${_currentUser.getCurrentUser.fullName}");
    CurrentGroup _currentGroup =
        Provider.of<CurrentGroup>(context, listen: false);
    log.d(
        "HomeScreenState.initState(): _currentGroup <= ${_currentGroup.getCurrentGroup.name}");
    _currentGroup.updateStateFromDatabase(_currentUser.getCurrentUser.groupId);
    log.d(
        "HomeScreenState.initState(): updated _currentGroup <= ${_currentGroup.getCurrentGroup.name}");
  }

  /// Navigates to noGroup screen
  void _goToNoGroup(BuildContext inContext) {
    Navigator.push(
      inContext,
      MaterialPageRoute(builder: (inContext) => OurNoGroup()),
    );
  }

  /// Signs out of an account
  void _signOut(BuildContext inContext) async {
    CurrentUser _currentUser =
        Provider.of<CurrentUser>(inContext, listen: false);
    String _returnString = await _currentUser.singOut();
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(inContext,
          MaterialPageRoute(builder: (context) => OurRoot()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 8,
          ),

          /// 1st Container
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Consumer<CurrentGroup>(
                builder: (BuildContext context, value, Widget child) {
                  return Column(
                    children: [
                      Text(
                        value.getCurrentBook.name ?? "loading...",
                        style: TextStyle(fontSize: 30, color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Text(
                              "Due in: ",
                              style: TextStyle(
                                  fontSize: 30, color: Colors.grey[600]),
                            ),
                            Expanded(
                              child: Text(
                                (value.getCurrentGroup.currentBookDue != null)
                                    ? value.getCurrentGroup.currentBookDue
                                        .toDate()
                                        .toString()
                                    : "loading...",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text(
                          "Finished Book",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          /// 2nd Container
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OurContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Next Book Revealed In: ",
                      style: TextStyle(fontSize: 30, color: Colors.grey[600]),
                    ),
                    Text(
                      "22 Hours",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Book club history button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: RaisedButton(
              onPressed: () => _goToNoGroup(context),
              child: Text("Book Club History",
                  style: TextStyle(color: Colors.white)),
            ),
          ),

          /// Sign out button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: RaisedButton(
              child: Text("Sign out"),
              onPressed: () => _signOut(context),
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
