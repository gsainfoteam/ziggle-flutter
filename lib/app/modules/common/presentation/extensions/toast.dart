import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  void showToast(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}
