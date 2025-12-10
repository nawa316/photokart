import 'dart:ui';
import 'package:flutter/material.dart';

class AppPopup {
  static Future<bool?> showDeleteConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              "Delete Product?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF304369),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: const Text(
              "Are you sure you want to delete this product? This action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF304369)),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              _btn(
                label: "Yes",
                bg: Color(0XFF7B95CF),
                onTap: () => Navigator.pop(context, true),
              ),
              _btn(
                label: "No",
                bg: Color(0XFFFF7272),
                onTap: () => Navigator.pop(context, false),
              ),
            ],
          ),
        );
      },
    );
  }
  static Future<void> showDeleteSuccess(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              "Deleted Successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF304369),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: const Text(
              "Product has been removed.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF304369)),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              _btn(
                label: "OK",
                bg: Color(0xFF7B95CF),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔹 Button reusable
  static Widget _btn({
    required String label,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(label),
    );
  }
}
