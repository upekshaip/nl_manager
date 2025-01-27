import 'package:flutter/material.dart';
import 'package:nl_manager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionStateProvider>(
      builder: (context, mySession, child) => GestureDetector(
        onTap: () {
          mySession.logOut();
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
          Navigator.pushNamed(context, '/login');
        },
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey.shade800)),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 15,
                ),
                Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
