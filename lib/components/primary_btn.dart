import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const PrimaryBtn({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(color: Colors.blueAccent.shade700, borderRadius: BorderRadius.circular(30), border: Border.all(color: Theme.of(context).colorScheme.primary)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
