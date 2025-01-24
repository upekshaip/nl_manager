import 'package:flutter/material.dart';

class MyLoading extends StatelessWidget {
  final String? message; // Optional loading message

  const MyLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(), // Spinner
          if (message != null) ...[
            const SizedBox(height: 8), // Space between spinner and message
          ],
        ],
      ),
    );
  }
}
