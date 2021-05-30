import 'package:book_club/states/currentGroup.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurReview extends StatefulWidget {
  // Declare the CurrentGroup variable to have the access to CurrentGroup datф
  final CurrentGroup currentGroup;

  const OurReview({Key key, this.currentGroup}) : super(key: key);

  @override
  _OurReviewState createState() => _OurReviewState();
}

class _OurReviewState extends State<OurReview> {
  TextEditingController _reviewController = TextEditingController();
  int _dropdownValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Row(
              children: [BackButton()],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: OurContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Rate book 1-10:    ",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      DropdownButton<int>(
                        value: _dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        onChanged: (int inNewValue) {
                          setState(() {
                            _dropdownValue = inNewValue;
                          });
                        },
                        items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            .map<DropdownMenuItem<int>>(
                                (int inValue) => DropdownMenuItem(
                                      value: inValue,
                                      child: Text(inValue.toString()),
                                    ))
                            .toList(),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      prefixIcon: (Icon(Icons.rate_review)),
                      hintText: "Add a review...",
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "Add Review",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      onPressed: () {
                        String uid =
                            Provider.of<CurrentUser>(context, listen: false)
                                .getCurrentUser
                                .uid;
                        widget.currentGroup.finishedBook(
                            uid, _dropdownValue, _reviewController.text);
                        Navigator.pop(context);
                      }),
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
