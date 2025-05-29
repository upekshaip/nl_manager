import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTextFeild extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool isEnabled;

  const MyTextFeild({super.key, required this.controller, required this.hintText, required this.obscureText, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        decoration: InputDecoration(labelText: hintText),
        enabled: isEnabled,
        controller: controller,
        obscureText: obscureText,
      ),
    );
  }
}
