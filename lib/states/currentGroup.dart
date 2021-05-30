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

  /// Flags if the user's done with a book
  bool _doneWithCurrentBook = false;

  /// Create getters for group and book instances
  OurGroup get getCurrentGroup => _currentGroup;
  OurBook get getCurrentBook => _currentBook;
  bool get getDoneWithCurrentBook => _doneWithCurrentBook;

  /// Updates the CurrentGroup state from the Firebase
  void updateStateFromDatabase(String inGroupId, String inUid) async {
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

      _doneWithCurrentBook = await OurDatabase().ifUserDoneWithBook(
        inGroupId,
        _currentGroup.currentBookId,
        inUid,
      );

      /// Pins app's listeners to refresh the screen
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /// An event of book finishing.
  /// Calls the firestore db to store the finished book data
  void finishedBook(String inUid, int inRating, String inReview) async {
    try {
      await OurDatabase().finishedBook(
        _currentBook.id,
        _currentGroup.id,
        inUid,
        inRating,
        inReview,
      );

      /// change the state and notify listeners;
      /// _doneWithCurrentBook is initialized to false above at its declaration
      _doneWithCurrentBook = true;
      notifyListeners();
    } catch (error) {
      log.e(error);
    }
  }
}
