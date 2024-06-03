import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppState with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  bool _isLoggedIn = false;
  bool _isEmailVerified = false;

  AppState(@Named('FirebaseAuthInstance') this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  bool get isLoggedIn => _isLoggedIn;

  bool get isEmailVerified => _isEmailVerified;

  void _onAuthStateChanged(User? user) {
    _isLoggedIn = user != null;
    _isEmailVerified = user != null && user.emailVerified;
    notifyListeners();
  }
}
