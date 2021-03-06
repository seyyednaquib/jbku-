// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jbku_project/backend/controller/user_controller.dart';
import 'package:jbku_project/backend/models/user.dart';
import 'package:jbku_project/screens/authenticate/signin.dart';
import 'package:jbku_project/backend/controller/report_controller.dart';

class UserAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //Sign In Anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth
          .signInAnonymously(); //request sign in anon to our firebase
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign In with Email and Password
  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with Email and password
  Future registerWithEmail(String email, String password, String nric,
      String fullname, String username, String location) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      //create a new document  for the user with the uid
      await UserController(uid: user.uid)
          .addUserInfo(nric, fullname, username, location);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
