// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jbku_project/backend/models/user.dart';

class UserController {
  final String uid;
  UserController({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future addUserInfo(
      String nric, String fullname, String username, String location) async {
    return await userCollection.document(uid).setData({
      'nric': nric,
      'fullname': fullname,
      'username': username,
      'location': location,
      'role': 'user',
      'pictUrl': '',
    });
  }

  Future addprofilepic(String pictUrl) async {
    return await userCollection.document(uid).updateData({
      'pictUrl': pictUrl,
    });
  }

//get user doc stream in User Setting Stream
  Stream<UserInformation> get userInformation {
    return userCollection
        .document(uid)
        .snapshots()
        .map((_userInformationFromSnapshot));
  }

  //userInformation from snapshot
  UserInformation _userInformationFromSnapshot(DocumentSnapshot snapshot) {
    return UserInformation(
        uid: uid,
        fullname: snapshot.data['fullname'],
        location: snapshot.data['location'],
        nric: snapshot.data['nric'],
        username: snapshot.data['username'],
        role: snapshot.data['role'],
        pictUrl: snapshot.data['pictUrl']);
  }

  Future<DocumentSnapshot> getData() async {
    return await userCollection.document(uid).get();
  }

  Future<String> getUserFullName() async {
    DocumentSnapshot snapshot = await getData();
    return snapshot.data['fullname'];
  }
}
