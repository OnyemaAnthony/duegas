import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormattedTextController extends TextEditingController {
  final NumberFormat formatter;
  String _rawText = '0';

  FormattedTextController({required this.formatter}) {
    addListener(_formatInput);
    text = formatter.format(0);
  }

  void _formatInput() {
    final raw = super.text;
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      _rawText = '0';
      super.value = TextEditingValue(
        text: formatter.format(0),
        selection: const TextSelection.collapsed(offset: 5),
      );
      return;
    }

    _rawText = digitsOnly;

    final double value = double.parse(digitsOnly) / 100;
    final formatted = formatter.format(value);

    super.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  String get text => (double.parse(_rawText) / 100).toStringAsFixed(2);
  String get formattedText => super.text;
}
