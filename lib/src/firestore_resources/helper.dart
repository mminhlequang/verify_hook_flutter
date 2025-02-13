import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

User get currentUser => FirebaseAuth.instance.currentUser!;

bool isUserLoggedIn() {
  return FirebaseAuth.instance.currentUser != null;
}

Future<bool> checkUserLoggedIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      await user.getIdToken(true);
      return true;
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  }
  return false;
}

Future<UserCredential> registerWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      throw Exception('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      throw Exception('An account already exists for that email.');
    }
    throw Exception('Error occurred during registration: ${e.message}');
  } catch (e) {
    throw Exception('An unexpected error occurred: $e');
  }
}

Future<UserCredential> loginWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw Exception('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw Exception('Wrong password provided.');
    }
    throw Exception('Error occurred during login: ${e.message}');
  } catch (e) {
    throw Exception('An unexpected error occurred: $e');
  }
}
