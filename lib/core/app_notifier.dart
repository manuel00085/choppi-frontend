import 'package:flutter/material.dart';

class AppNotifier {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showError(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  static void showWarning(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.yellow,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
