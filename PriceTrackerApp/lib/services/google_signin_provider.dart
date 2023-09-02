import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  // This function initiates the Google Sign-In process.
  // It retrieves user information and authenticates with Firebase.
  Future googleSignin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    // Store the signed-in Google user
    _user = googleUser;

    // Retrieve authentication information from the signed-in user
    final googleAuth = await googleUser.authentication;

    // Create a Firebase credential using Google authentication tokens
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase using the generated credential
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Notify listeners that the user state has changed
    notifyListeners();
  }
}
