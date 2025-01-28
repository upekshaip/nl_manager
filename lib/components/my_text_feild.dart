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
          style: Theme.of(context).textTheme.labelLarge, // Changes the text color when typing

          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          )),
    );
  }
}
