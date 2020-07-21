import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loggedIn = false;
  bool isLoggedIn() => _loggedIn;

  void login() async{
    var user = await _handleSignIn();

    if (user != null) {
      _loggedIn = true;
    } else {
      _loggedIn = false;
    }
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)) as FirebaseUser;
    print("signed in" + user.displayName);
    return user;
  }
/*
  Future<FirebaseUser> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
  */
}