import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../features/shared/data/models/user.dart';
import '../../features/shared/domain/repositories/user_repository.dart';
import '../api/result_status.dart';
import '../dependency_injection/dependency_injection.dart';

@singleton
class AppState with ChangeNotifier {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  bool _isLoggedIn = false;
  bool _isEmailVerified = false;
  User? _user;

  AppState(
    @Named(firebaseAuthInstance) this._firebaseAuth,
    this._userRepository,
  ) {
    _initialize();
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get isEmailVerified => _isEmailVerified;
  User? get user => _user;

  Future<void> _initialize() async {
    if (kIsWeb) {
      await _firebaseAuth.setPersistence(firebase_auth.Persistence.LOCAL);
    }
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(firebase_auth.User? user) async {
    _updateAuthState(user);
    if (_isLoggedIn && user != null) {
      await _fetchUserProfile(user.uid);
    }
    notifyListeners();
  }

  void _updateAuthState(firebase_auth.User? user) {
    _isLoggedIn = user != null;
    _isEmailVerified = user != null && user.emailVerified;
    if (!_isLoggedIn) {
      _user = null;
    }
  }

  Future<void> _fetchUserProfile(String userId) async {
    final response = await _userRepository.getUserProfile(userId);
    if (response.result == ResultStatus.success) {
      _user = response.data;
    } else {
      _user = null;
    }
  }
}
