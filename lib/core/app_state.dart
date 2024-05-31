import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthState with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setLogin(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}
