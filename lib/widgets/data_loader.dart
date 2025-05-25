import 'package:flutter/material.dart';

Future<String> loadData() async {
  print("Fetching data from server...");
  await Future.delayed(Duration(seconds: 2));
  print("Data fetched successfully");
  return "Data loaded: Welcome to the dashboard!";
}

class DataLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: Text(
              snapshot.data ?? "No data found",
              style: TextStyle(fontSize: 18),
            ),
          );
        }
      },
    );
  }
}
