import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../dependency_injection/dependency_injection.dart';

@singleton
class AppState with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  bool _isLoggedIn = false;
  bool _isEmailVerified = false;

  String? _userId;

  AppState(@Named(firebaseAuthInstance) this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  bool get isLoggedIn => _isLoggedIn;

  bool get isEmailVerified => _isEmailVerified;

  String? get userId => _userId;

  void _onAuthStateChanged(User? user) {
    _isLoggedIn = user != null;
    _userId = user?.uid;
    _isEmailVerified = user != null && user.emailVerified;
    notifyListeners();
  }
}
