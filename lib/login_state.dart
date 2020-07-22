import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;

  bool _loggedIn = false;
  bool _loading = true;
  FirebaseUser _user;

  LoginState() {
    loginState();
  }

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  FirebaseUser currentUser() => _user;

  void login() async {
    _loading = true;
    notifyListeners();

    _user = await _handleSignIn();

    _loading = false;
    if (_user != null) {
      _prefs.setBool("isLoggedIn", true);
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  void logout() {
    _prefs.clear();
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  // This code come from pub.dev, searching google_sign_in. Help us to sync data account
  // with this app, generating an id to search in data base
  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  // Next we can do that the app "remember" or have persistence of the last user that
  // ingress to our app, so, the user haven't that use select the Google Account that require
  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey("isLoggedIn")) {
      _user = await _auth.currentUser();
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }
}