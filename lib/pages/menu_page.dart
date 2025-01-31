import 'package:flutter/material.dart';
import 'package:nlmanager/components/logout_btn.dart';
import 'package:nlmanager/components/my_square_btn.dart';
import 'package:nlmanager/components/todos/my_todo_list.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/permission_service.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:nlmanager/tasks/settings_state.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionStateProvider, CourseStateProvider, SettingsStateProvider>(
      builder: (context, mySession, myCourse, mySettings, child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Menu', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to NL Manager",
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Loged in as ${mySession.tokens['username']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const LogoutBtn()
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MySquareBtn(
                          onPressed: () async {
                            bool status = await MyPermissions().checkPermissions();
                            if (status) {
                              Navigator.pushNamed(context, '/modules');
                            } else {
                              MyHelper().showPermissionDialog(context);
                            }
                          },
                          icon: Icons.book,
                          label: "Modules",
                          color: Color.fromARGB(255, 14, 182, 19),
                        ),
                        MySquareBtn(
                          onPressed: () async {
                            bool status = await MyPermissions().checkPermissions();
                            if (status) {
                              Navigator.pushNamed(context, '/downloader');
                            } else {
                              MyHelper().showPermissionDialog(context);
                            }
                          },
                          icon: Icons.download,
                          label: "Downloader",
                          color: Color.fromARGB(255, 221, 132, 0),
                        ),
                        MySquareBtn(
                          onPressed: () {
                            mySettings.loadSettings();
                            Navigator.pushNamed(context, '/settings');
                          },
                          icon: Icons.settings,
                          label: "Settings",
                          color: const Color.fromARGB(255, 1, 138, 251),
                        ),
                      ],
                    )),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const TodosList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
