import 'package:flutter/material.dart';
import 'package:nlmanager/components/my_loading.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';
import '../components/course/my_list.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer2<SessionStateProvider, CourseStateProvider>(
        builder: ((context, mySession, myCourse, child) => Scaffold(
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
                  backgroundColor: Colors.blueGrey,
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
                        tooltip: 'Refresh 1',
                        onPressed: () {
                          myCourse.refresh(mySession);
                        },
                        color: Colors.white,
                      ),
                    ),
                  ]),
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (myCourse.isLoading)
                        const MyLoading(
                          message: "🔍 Scanning...",
                        ),
                      if (myCourse.courseData.isEmpty && !myCourse.isLoading)
                        Column(
                          // optional
                          children: [
                            Text('Refresh to scan courses 🔍'),
                          ],
                        ),
                      if (myCourse.courseData.isNotEmpty && !myCourse.isLoading)
                        MyCourseList(courses: myCourse.courseData),
                    ],
                  ),
                ),
              ),
            )));
  }
}
