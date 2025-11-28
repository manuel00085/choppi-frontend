import 'package:flutter/material.dart';

class AppLoading {
  static bool _showing = false;

  static void show(BuildContext context) {
    if (_showing) return;
    _showing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (_showing) {
      _showing = false;
      Navigator.of(context).pop();
    }
  }
}
