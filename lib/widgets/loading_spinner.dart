import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final String? message;

  const LoadingSpinner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 12),
            Text(message!, style: TextStyle(fontSize: 16))
          ],
        ],
      ),
    );
  }
}
