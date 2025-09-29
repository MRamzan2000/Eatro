import 'package:eatro/main.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  // Success Snackbar
  static void showSuccess(String message) {
    _show(
      message: message,
      bgColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
  }

  // Error Snackbar
  static void showError(String message) {
    _show(
      message: message,
      bgColor: Colors.red.shade600,
      icon: Icons.error,
    );
  }

  // Common private method
  static void _show({
    required String message,
    required Color bgColor,
    required IconData icon,
  }) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: bgColor,
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
