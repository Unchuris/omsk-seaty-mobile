import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omsk_seaty_mobile/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<bool> isSignedIn() async {
    if (await _checkUserInPreferences())
      return true;
    else {
      final currentUser = await _firebaseAuth.currentUser();
      return currentUser != null;
    }
  }

  Future signOut() async {
    _removeUserFromPreferences();
    Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<User> getUser() async {
    if (await _checkUserInPreferences())
      return _getUserFromPrefs();
    else
      return _getUserFromFirebase();
  }

  void saveUserToPreferences(User user) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('user', json.encode(user));
  }

  void _removeUserFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('user');
  }

  Future<bool> _checkUserInPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    var user = preferences.getString('user') ?? '';
    if (user != '')
      return true;
    else
      return false;
  }

  Future<User> _getUserFromFirebase() async {
    var firebaseUser = await _firebaseAuth.currentUser();
    return User(firebaseUser.uid, firebaseUser.displayName, firebaseUser.email,
        firebaseUser.photoUrl);
  }

  Future<User> _getUserFromPrefs() async {
    final preferences = await SharedPreferences.getInstance();
    var user = json.decode(preferences.getString('user'));
    return User.fromJson(user);
  }
}
