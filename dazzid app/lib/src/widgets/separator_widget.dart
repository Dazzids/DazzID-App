import 'package:flutter/material.dart';

class SeparatorWidget extends StatelessWidget {
  final double height;

  const SeparatorWidget({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
