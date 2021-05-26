import 'package:book_club/models/book.dart';
import 'package:book_club/screens/root/root.dart';
import 'package:book_club/services/database.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import "package:logger/logger.dart";

var log = Logger();

class OurAddBook extends StatefulWidget {
  /// New fields.
  final bool onGroupCreation;
  final String groupName;

  /// Constructor.
  OurAddBook({
    this.onGroupCreation,
    this.groupName,
  });

  /// Overrides createState() method to initialize _OurBookState instance
  @override
  _OurAddBookState createState() => _OurAddBookState();
}

/// Defines _OurBookState class
class _OurAddBookState extends State<OurAddBook> {
  /// Initializes TextEditingController instance
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();

  /// Creates DateTime instance and fills it with current datetime
  DateTime _selectedDate = DateTime.now();

  /// ---------- Methods ----------

  /// Shows DatePicker and if it's not null or now() sets _selectedDate stete to
  /// picked Date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        await DatePicker.showDatePicker(context, showTitleActions: true);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Adds a book either on groupCreation or in existing group
  _addBook(BuildContext inContext, String inGroupName, OurBook inBook) async {
    /// Gets the CurrentUser instance and assigns it to _currentUser variable
    CurrentUser _currentUser =
        Provider.of<CurrentUser>(inContext, listen: false);

    /// Sets the return to "error" by default
    String _returnString;
    if (widget.onGroupCreation) {
      /// Creates a group with a  book  in firebase and gets "success"/"error" status
      _returnString = await OurDatabase()
          .createGroup(inGroupName, _currentUser.getCurrentUser.uid, inBook);
    } else {
      /// Adds a book to the existing group
      _returnString = await OurDatabase()
          .addBook(_currentUser.getCurrentUser.groupId, inBook);
    }

    /// If _returnString is "success", navigates to OurRoot screen
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          inContext,
          MaterialPageRoute(builder: (inContext) => OurRoot()),
          (route) => false);
    }
  }

  /// ----------- View -----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                  /// Book Name
                  TextFormField(
                    controller: _bookNameController,
                    decoration: InputDecoration(
                      prefixIcon: (Icon(Icons.book)),
                      hintText: "Book Name",
                    ),
                  ),
                  SizedBox(height: 20.0),

                  /// Book Author
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      prefixIcon: (Icon(Icons.person)),
                      hintText: "Author",
                    ),
                  ),
                  SizedBox(height: 20.0),

                  /// Book length
                  TextFormField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      prefixIcon: (Icon(Icons.auto_awesome_motion)),
                      hintText: "Number of pages",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 40.0),

                  /// Date picker
                  Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
                  Text(DateFormat("HH:mm").format(_selectedDate)),
                  FlatButton(
                    child: Text("Change date"),
                    onPressed: () => _selectDate(context),
                  ),
                  SizedBox(height: 20.0),

                  /// Add book Button
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
                      onPressed: () {
                        /// Creates new OurBook instance and sets fields with
                        /// input values
                        OurBook newBook = OurBook();
                        newBook.name = _bookNameController.text;
                        newBook.author = _authorController.text;
                        newBook.length = int.parse(_lengthController.text);
                        newBook.dateCompleted =
                            Timestamp.fromDate(_selectedDate);
                        log.d("widget.groupName = ${widget.groupName}");
                        _addBook(context, widget.groupName, newBook);
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
