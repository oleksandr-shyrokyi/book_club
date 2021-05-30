import 'dart:async';

import 'package:book_club/screens/addBook/addBook.dart';
import 'package:book_club/screens/review/review.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/utils/timeLeft.dart';
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
  /// [0] - time until the book is due; [1] - time until the book is revealed
  List<String> _timeUntil = List(2);
  Timer _timer;

  /// Starts timer and changes _timeUntil[Due,Revealed] state values simultaneously
  /// Takes _currentGroup instance to reach _currentBookDue field
  /// The callback waits for next timer value and reacts to it, calling .timeLeft() method
  void _startTimer(CurrentGroup inCurrentGroup) {
    _timer = Timer.periodic(Duration(seconds: 1), (inTimer) {
      setState(() {
        /// .toDate() converts to DateTime, as currentBookDue is of Timestamp type
        _timeUntil = OurTimeLeft()
            .timeLeft(inCurrentGroup.getCurrentGroup.currentBookDue.toDate());
      });
    });
  }

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
    _currentGroup.updateStateFromDatabase(
        _currentUser.getCurrentUser.groupId, _currentUser.getCurrentUser.uid);
    log.d(
        "HomeScreenState.initState(): updated _currentGroup <= ${_currentGroup.getCurrentGroup.name}");

    /// Calls the start timer to pass it a _currentGroup instance
    _startTimer(_currentGroup);
  }

  /// We start time on .initState() but we have to dispose(избавляться) it as well
  /// if we leave the screen the timer stops running
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Navigates to noGroup screen
  void _goToAddBook(BuildContext inContext) {
    Navigator.push(
      inContext,
      MaterialPageRoute(
        builder: (inContext) => OurAddBook(
          onGroupCreation: false,
        ),
      ),
    );
  }

  void _goToReview(BuildContext inContext) {
    /// Initialises the current group from Provider
    CurrentGroup _currentGroup = Provider.of<CurrentGroup>(
      context,
      listen: false,
    );
    Navigator.push(
      inContext,
      MaterialPageRoute(
        builder: (inContext) => OurReview(
          // Passes the _currentGroup to OurReview.currentGroup field
          currentGroup: _currentGroup,
        ),
      ),
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
            height: 20.0,
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
                                /// takes the first value of _timeUntil
                                _timeUntil[0] ?? "loading...",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () => value.getDoneWithCurrentBook
                            ? null
                            : _goToReview(context),
                        child: value.getDoneWithCurrentBook
                            ? Text(
                                "Finished book!",
                                style: TextStyle(
                                  color: Colors.green[200],
                                ),
                              )
                            : Text(
                                "Finish Book",
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Next Book\nRevealed In: ",
                      style: TextStyle(fontSize: 30, color: Colors.grey[600]),
                    ),
                    Text(
                      /// takes the second value of _timeUntil
                      _timeUntil[1] ?? "loading...",
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
              onPressed: () => _goToAddBook(context),
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
