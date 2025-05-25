import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;

  const ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    print("Opening profile screen for $username");

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Text("Hello, $username!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
