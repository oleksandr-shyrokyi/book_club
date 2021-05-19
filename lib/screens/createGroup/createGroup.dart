import 'package:book_club/screens/root/root.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurCreateGroup extends StatefulWidget {
  const OurCreateGroup({Key key}) : super(key: key);

  @override
  _OurCreateGroupState createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {
  TextEditingController _groupNameController = TextEditingController();

  _createGroup(BuildContext inContext, String groupName) async {
    CurrentUser _currentUser =
        Provider.of<CurrentUser>(inContext, listen: false);
    String _returnString = await OurDatabase()
        .createGroup(groupName, _currentUser.getCurrentUser.uid);
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
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      prefixIcon: (Icon(Icons.group)),
                      hintText: "GroupName",
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _createGroup(context, _groupNameController.text),
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
