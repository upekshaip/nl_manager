import 'package:flutter/material.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/downloader_state.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionStateProvider, CourseStateProvider, DownloadStateProvider>(
      builder: (context, mySession, myCourse, myDownloader, child) => GestureDetector(
        onTap: () {
          mySession.logOut(myCourse, myDownloader);
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
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.semibold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}