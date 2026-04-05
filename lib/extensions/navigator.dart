import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  Future<dynamic> push(Widget page) {
    return Navigator.push(
      this,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  Future<dynamic> pushReplacement(Widget page) {
    return Navigator.pushReplacement(
      this,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  Future<dynamic> pushAndRemoveUntil(Widget page) {
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (_) => page,
      ),
      (route) => false,
    );
  }

  void pop() {
    Navigator.pop(this);
  }
}