import 'package:book_club/models/book.dart';
import 'package:book_club/models/group.dart';
import 'package:book_club/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

/// Logger() instance for code logging
var log = Logger();

class OurDatabase {
  final Firestore _firestore = Firestore.instance;

  Future<String> createUser(OurUser inUser) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").document(inUser.uid).setData({
        "fullName": inUser.fullName,
        "email": inUser.email,
        "accountCreated": Timestamp.now(),
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String inUid) async {
    OurUser retVal = OurUser();

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").document(inUid).get();
      retVal.uid = inUid;
      retVal.fullName = _docSnapshot.data['fullName'];
      retVal.email = _docSnapshot.data['email'];
      retVal.accountCreated = _docSnapshot.data['accountCreated'];
      retVal.groupId = _docSnapshot.data['groupId'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createGroup(String groupName, String userId) async {
    String retVal = "error";

    List<String> members = List();

    try {
      members.add(userId);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        "name": groupName,
        "leader": userId,
        "members": members,
        "groupCreated": Timestamp.now(),
      });

      await _firestore.collection("users").document(userId).updateData({
        "groupId": _docRef.documentID,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userId) async {
    String retVal = "error";

    List<String> members = List();

    try {
      members.add(userId);
      await _firestore.collection("groups").document(groupId).updateData({
        "members": FieldValue.arrayUnion(members),
      });

      await _firestore.collection("users").document(userId).updateData({
        "groupId": groupId,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurGroup> getGroupInfo(String inGroupId) async {
    log.d("OurDatabase.getGroupInfo(inGroupId <= $inGroupId): started");

    /// Creates an empty instance of [OurGroup] class
    OurGroup retVal = OurGroup();
    log.d(
        "OurDatabase.getGroupInfo(): created retVal = new OurGroup() instance");

    /// Tries to get the info from the Firebase and set it to [retVal] instance
    /// of [OurGroup] class
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("groups").document(inGroupId).get();
      log.d(
          "OurDatabase.getGroupInfo(): obtained _docSnapshot <= ${_docSnapshot.data["name"]}");

      retVal.id = inGroupId;
      retVal.name = _docSnapshot.data['name'];
      retVal.leader = _docSnapshot.data['leader'];
      retVal.members = List<String>.from(_docSnapshot.data['members']);
      retVal.groupCreated = _docSnapshot.data['groupCreated'];
      retVal.currentBookId = _docSnapshot.data['currentBookId'];
      retVal.currentBookDue = _docSnapshot.data['currentBookDue'];

      log.d(
          "OurDatabase.getGroupInfo(): Got OurGroup retVal <= {${retVal.name}, "
          "${retVal.leader}, ${retVal.members}, ${retVal.groupCreated},"
          "${retVal.currentBookId}, ${retVal.currentBookDue}}");
    } catch (e) {
      print(e);
    }

    /// Returns Future<OurGroup> instance filled with the data from Firestore
    return retVal;
  }

  Future<OurBook> getCurrentBook(String inGroupId, String inBookId) async {
    log.d(
        "OurDatabase.getCurrentBook(inGroupId <= $inGroupId, inBookId <= $inBookId): started");

    /// Creates an empty instance of [OurBook] class
    OurBook retVal = OurBook();
    log.d(
        "OurDatabase.getCurrentBook(): created retVal = new OurBook() instance");

    /// Tries to get the info from the Firebase and set it to [retVal] instance
    /// of [OurBook] class. Note that on Firebase the "books" collection is the
    /// sub-collection of "groups" collection
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(inGroupId)
          .collection("books")
          .document(inBookId)
          .get();
      log.d(
          "OurDatabase.getCurrentBook(): obtained _docSnapshot <= ${_docSnapshot.data["name"]}");

      retVal.id = inBookId;
      retVal.name = _docSnapshot.data['name'];
      retVal.length = _docSnapshot.data['length'];
      retVal.dateCompleted = _docSnapshot.data['dateCompleted'];
      log.d(
          "OurDatabase.getCurrentBook(): Got OurBook retVal <= {${retVal.name}, "
          "${retVal.length}, ${retVal.dateCompleted}}");
    } catch (e) {
      print(e);
    }

    /// Returns Future<OurBook> instance filled with the data from Firestore
    return retVal;
  }
}
