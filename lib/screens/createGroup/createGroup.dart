import 'package:book_club/screens/addBook/addBook.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';

class OurCreateGroup extends StatefulWidget {
  const OurCreateGroup({Key key}) : super(key: key);

  @override
  _OurCreateGroupState createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {
  TextEditingController _groupNameController = TextEditingController();

  /// Navigates to AddOurBook screen
  _goToAddBook(BuildContext inContext, String inGroupName) async {
    Navigator.push(
      inContext,
      MaterialPageRoute(
        builder: (inContext) => OurAddBook(
          onGroupCreation: true,
          groupName: inGroupName,
        ),
      ),
    );
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
                      hintText: "Group Name",
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Add Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _goToAddBook(context, _groupNameController.text),
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
