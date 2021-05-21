import 'package:book_club/models/book.dart';
import 'package:book_club/models/group.dart';
import 'package:book_club/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:logger/logger.dart";

var log = Logger();

class CurrentGroup extends ChangeNotifier {
  /// Creates an instance of a group named _currentGroup
  OurGroup _currentGroup = OurGroup();

  /// Creates an instance of a book named _current Book
  OurBook _currentBook = OurBook();

  /// Create getters for group and book instances
  OurGroup get getCurrentGroup => _currentGroup;
  OurBook get getCurrentBook => _currentBook;

  /// Updates the CurrentGroup state from the Firebase
  void updateStateFromDatabase(String inGroupId) async {
    log.d(
        "CurrentGroup.updateStateFromDatabase(groupId <= $inGroupId): started");
    try {
      /// Gets the current group info form Firebase.
      /// Logs are inside the method
      _currentGroup = await OurDatabase().getGroupInfo(inGroupId);

      /// Gets the current book info from Firebase.
      /// Note that the currentBookId is inside the _currentGroup instance.
      /// Logs are inside the method.
      _currentBook = await OurDatabase()
          .getCurrentBook(inGroupId, _currentGroup.currentBookId);

      /// Pins app's listeners to refresh the screen
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
