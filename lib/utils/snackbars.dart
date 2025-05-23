import 'package:flutter/material.dart';

void showDownloadSuccess(BuildContext context, String fileName) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('✅ Downloaded "$fileName"'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ),
  );
}
