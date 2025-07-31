import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ToastMessage on BuildContext {
  void showCustomToast({
    required String message,
    bool isError = false,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 14.0,
    int durationInSeconds = 2,
    bool showIcon = false,
    IconData? icon,
    Color iconColor = Colors.white,
  }) {
    FToast fToast = FToast();
    fToast.init(this);

    Widget toastContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isError ? Colors.red : backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && icon != null) ...[
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: fontSize),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toastContent,
      gravity: gravity,
      toastDuration: Duration(seconds: durationInSeconds),
    );
  }
}
