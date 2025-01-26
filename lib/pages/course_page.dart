import 'package:flutter/material.dart';
import 'package:nl_manager/tasks/course_task.dart';
import 'package:nl_manager/tasks/session_state.dart';
import 'package:provider/provider.dart';

import '../components/my_list.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isLoading = false;
  dynamic courseData = {"courses": [], "todos": []};
  bool isLoaded = false;
  String error = "";

  void refresh() async {
    setState(() {
      error = "";
      isLoading = true;
    });

    final mySession = context.read<SessionStateProvider>();
    final session = mySession.getMySession();
    final course = Course(tokens: mySession.tokens.cast<String, String?>(), session: session, reverseDays: 15);
    courseData = await course.getCourses();
    if (courseData.containsKey("error")) {
      setState(() {
        error = courseData["error"];
        isLoading = false;
        isLoaded = false;
      });
      return;
    }
    var finalData = await course.getAllCourseInfo(courseData["courses"]);
    if (finalData == null) {
      setState(() {
        error = "Failed to get course info";
        isLoading = false;
        isLoaded = false;
      });
      return;
    }

    setState(() {
      isLoading = false;
      isLoaded = true;
      error = "";
      courseData["courses"] = finalData;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<SessionStateProvider>(
        builder: ((context, mySession, child) => Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.blue.shade900,
                  title: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Modules',
                        style: TextStyle(color: Colors.white),
                      )),
                  // automaticallyImplyLeading: false,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                        onPressed: refresh,
                        color: Colors.white,
                      ),
                    ),
                  ]),
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading) const CircularProgressIndicator(),
                      if (!isLoaded)
                        Column(
                          children: [
                            for (var entry in mySession.tokens.entries) Text('${entry.key}: ${entry.value}'),
                          ],
                        ),
                      if (isLoaded && !isLoading) MyCourseList(courses: courseData["courses"]),
                    ],
                  ),
                ),
              ),
            )));
  }
}
