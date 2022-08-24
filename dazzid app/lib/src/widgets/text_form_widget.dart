import 'package:dazz/src/utils/no_format_text.dart';
import 'package:dazz/src/utils/uppercase_text.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType keyboardType;
  final bool isCapitalize;
  final bool enabled;
  final Function validator;
  final Function onChange;
  final TextEditingController controller;
  final String hintText;
  final int maxLength;

  const CustomTextFormField(
      {Key key,
      this.keyboardType = TextInputType.name,
      this.isCapitalize = false,
      this.enabled = true,
      this.validator,
      this.onChange,
      @required this.controller,
      @required this.hintText,
      this.maxLength = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .8,
      child: TextFormField(
        controller: controller,
        validator: validator,
        enabled: enabled,
        maxLength: maxLength,
        inputFormatters: [
          isCapitalize ? UppercaseTextFormatter() : NoFormatText()
        ],
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintText: hintText, contentPadding: EdgeInsets.only(bottom: 20.0)),
        style: TextStyle(
          fontSize: 22.0,
        ),
      ),
    );
  }
}
