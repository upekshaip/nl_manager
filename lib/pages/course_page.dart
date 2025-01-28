import 'package:flutter/material.dart';
import 'package:nlmanager/tasks/course_task.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';

import '../components/course/my_list.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isLoading = false;
  String error = "";

  void refresh() async {
    setState(() {
      error = "";
      isLoading = true;
    });

    final mySession = context.read<SessionStateProvider>();
    final session = mySession.getMySession();
    final course = Course(tokens: mySession.tokens.cast<String, String?>(), session: session, reverseDays: 15);
    Map<String, dynamic> courseData = await course.getCourses();
    if (courseData.containsKey("error")) {
      setState(() {
        error = courseData["error"];
        isLoading = false;
      });
      return;
    }
    var finalData = await course.getAllCourseInfo(courseData["courses"]);
    if (finalData == null) {
      setState(() {
        error = "Failed to get course info";
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = false;
      error = "";
      mySession.setCourseData(finalData);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<SessionStateProvider>(
        builder: ((context, mySession, child) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Colors.black,
                  title: const Text(
                    'Modules',
                    style: TextStyle(color: Colors.white),
                  ),
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
                      if (mySession.courseData.isEmpty)
                        Column(
                          children: [
                            for (var entry in mySession.tokens.entries) Text('${entry.key}: ${entry.value}', style: TextStyle(color: Colors.grey.shade400)),
                          ],
                        ),
                      if (mySession.courseData.isNotEmpty && !isLoading) MyCourseList(courses: mySession.courseData),
                    ],
                  ),
                ),
              ),
            )));
  }
}
