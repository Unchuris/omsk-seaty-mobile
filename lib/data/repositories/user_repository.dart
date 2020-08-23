import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:omsk_seaty_mobile/data/models/user.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  String _uid;

  static const String _isSkippedPreferencesValue = 'isSkipped';
  static const String _userPreferencesValue = 'user';

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future init() async {
    _uid = await _getUserUid();
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    var user = await _firebaseAuth.currentUser();
    _uid = user.uid;
    return user;
  }

  Future<bool> isSignedIn() async {
    if (await _checkUserInPreferences())
      return true;
    else {
      final currentUser = await _firebaseAuth.currentUser();
      return currentUser != null;
    }
  }

  String getUid() {
    return (_uid != null) ? _uid : "";
  }

  Future<String> _getUserUid() async {
    if (_uid != null) return _uid;

    if (await isSignedIn()) {
      var user = await getUser();
      if (user != null) {
        _uid = user.uid;
        return _uid;
      }
    }
    return null;
  }

  Future signOut() async {
    _removeUserFromPreferences();
    _uid = null;
    Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<User> getUser() async {
    if (await _checkUserInPreferences())
      return _getUserFromPrefs();
    else
      return _getUserFromFirebase();
  }

  Future<bool> isSkipped() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isSkippedPreferencesValue) != null;
  }

  void saveIsSkipped() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(_isSkippedPreferencesValue, true);
  }

  void removeIsSkipped() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(_isSkippedPreferencesValue);
  }

  void saveUserToPreferences(User user) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(_userPreferencesValue, json.encode(user));
  }

  void _removeUserFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(_userPreferencesValue);
  }

  Future<bool> _checkUserInPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_userPreferencesValue) != null;
  }

  Future<User> _getUserFromFirebase() async {
    var firebaseUser = await _firebaseAuth.currentUser();
    return User(firebaseUser.uid, firebaseUser.displayName, firebaseUser.email,
        firebaseUser.photoUrl);
  }

  Future<User> _getUserFromPrefs() async {
    final preferences = await SharedPreferences.getInstance();
    var user = json.decode(preferences.getString(_userPreferencesValue));
    return User.fromJson(user);
  }
}
