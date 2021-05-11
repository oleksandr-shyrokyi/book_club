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
      retVal.fullName = _docSnapshot.data['email'];
      retVal.fullName = _docSnapshot.data['accountCreated'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
