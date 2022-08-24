import 'package:flutter/services.dart';

class NoFormatText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue;
  }
}
