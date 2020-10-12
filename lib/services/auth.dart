import 'package:bot_toast/bot_toast.dart';
import 'package:chatApp/helper/helperfunction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User1 _usercheck(User user) {
    if (user != null) {
      return User1(userId: user.uid);
    } else {
      return null;
    }
  }

  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return _usercheck(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 0;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 1;
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _usercheck(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');

        return 0;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 1;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      BotToast.showText(
        text: "logged out Successfully",
      );
      HelperFunction.saveuserLoggedInSharedPreference(false);
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
