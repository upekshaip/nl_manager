import 'package:flutter/material.dart';

class TapCounter extends StatefulWidget {
  @override
  _TapCounterState createState() => _TapCounterState();
}

class _TapCounterState extends State<TapCounter> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
      print("Button tapped: $count times");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Tap count: $count"),
        ElevatedButton(
          onPressed: increment,
          child: Text("Tap me"),
        ),
      ],
    );
  }
}