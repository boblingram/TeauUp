import 'package:flutter/material.dart';

class ErrorListWidget extends StatelessWidget {
  final String text;
  const ErrorListWidget({super.key, required this.text, });

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
