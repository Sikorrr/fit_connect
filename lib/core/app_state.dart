import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppState with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoggedIn = false;

  AppState() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  bool get isLoggedIn => _isLoggedIn;

  void _onAuthStateChanged(User? user) {
    _isLoggedIn = user != null;
    notifyListeners();
  }
}
