import 'package:book_club/screens/root/root.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

var log = Logger();

class OurJoinGroup extends StatefulWidget {
  const OurJoinGroup({Key key}) : super(key: key);

  @override
  _OurJoinGroupState createState() => _OurJoinGroupState();
}

class _OurJoinGroupState extends State<OurJoinGroup> {
  TextEditingController _groupIdController = TextEditingController();

  _joinGroup(BuildContext inContext, String groupId) async {
    log.d("Starting _joinGroup()");

    CurrentUser _currentUser =
        Provider.of<CurrentUser>(inContext, listen: false);
    print("################_currentUser = $_currentUser");

    String _returnString =
        await OurDatabase().joinGroup(groupId, _currentUser.getCurrentUser.uid);
    print("_returnString = $_returnString");

    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          inContext,
          MaterialPageRoute(builder: (inContext) => OurRoot()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: [
                  TextFormField(
                    controller: _groupIdController,
                    decoration: InputDecoration(
                      prefixIcon: (Icon(Icons.group)),
                      hintText: "Group Id",
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        "Join",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _joinGroup(context, _groupIdController.text),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
