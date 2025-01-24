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
          enabled: isEnabled,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade800), borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600),
          )),
    );
  }
}
