import 'package:flutter/material.dart';
import 'package:nl_manager/tasks/course_task.dart';
import 'package:nl_manager/tasks/session_state.dart';
import 'package:provider/provider.dart';

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
    setState(() {
      isLoading = false;
      isLoaded = true;
      error = "";
      courseData = courseData?["courses"];
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
                        'Course Page',
                        style: TextStyle(color: Colors.white),
                      )),
                  automaticallyImplyLeading: false,
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
                      if (isLoaded && !isLoading)
                        Expanded(
                          child: ListView.builder(
                            itemCount: courseData.length,
                            itemBuilder: (context, index) {
                              final course = courseData[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Course Name
                                      Text(
                                        course["fullname"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Course Details
                                      // Text('ID: ${course["id"]}'),
                                      // Text('${course["fullnamedisplay"]}'),
                                      const SizedBox(height: 8),
                                      // Course Progress
                                      Row(
                                        children: [
                                          const Text('Progress: '),
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: (course["progress"] as int) / 100,
                                              backgroundColor: Colors.grey.shade300,
                                              color: Colors.blue.shade500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text('${course["progress"]}%'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // View URL
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'View Course',
                                          style: TextStyle(
                                            color: Colors.blue.shade800,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
