import 'package:book_club/models/group.dart';
import 'package:book_club/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
