import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    print("Attempting login with username: $username");

    if (username == "admin" && password == "1234") {
      print("Login successful");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome back, $username")),
      );
    } else {
      print("Login failed: invalid credentials");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: TextStyle(fontSize: 28)),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => handleLogin(context),
              child: Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}