import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension PaddingAll on Widget {
  Padding paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
      );
}

extension OnClick on Widget {
  Widget onClick(VoidCallback callback) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: callback,
        child: this,
      );
}

extension Height on BuildContext {
  double get height => MediaQuery.of(this).size.height;
}

extension Width on BuildContext {
  double get width => MediaQuery.of(this).size.width;
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension ValidateEmail on String {
  bool isValidEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
}

extension TxtTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension FormatDateExtension on String {
  String toFormattedDate() {
    try {
      final parsedDate = DateTime.parse(this);
      return DateFormat('MMM dd, yyyy').format(parsedDate);
    } catch (e) {
      return this;
    }
  }
}

extension FormatTimeExtension on String {
  String toFormattedTime() {
    try {
      final parsedDate = DateTime.parse(this);
      return DateFormat('MMM dd, yyyy hh:mm a').format(parsedDate);
    } catch (e) {
      return this;
    }
  }
}
