import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isGuest = false;
  bool get isGuest => _isGuest;

  void setGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }
}
