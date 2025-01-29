import 'package:flutter/material.dart';
import 'package:nlmanager/components/my_loading.dart';
import 'package:nlmanager/tasks/course_task.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/permission_service.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class DownloaderPage extends StatefulWidget {
  const DownloaderPage({super.key});

  @override
  State<DownloaderPage> createState() => _DownloaderPageState();
}

class _DownloaderPageState extends State<DownloaderPage> {
  bool isLoading = false;
  String error = "";

  void refresh() async {
    // await MyPermissions().createFolder("CS/course");
    // print(await MyPermissions().getFiles());
    setState(() {
      error = "";
      isLoading = true;
    });
    final mySession = context.read<SessionStateProvider>();
    final session = mySession.getMySession();
    final course = Course(tokens: mySession.tokens.cast<String, String?>(), session: session, reverseDays: 15);
    Map<String, dynamic> courseData = await course.getAllCourses();
    if (courseData.containsKey("error")) {
      setState(() {
        error = courseData["error"];
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        error = "";
        isLoading = false;
      });
      // print(courseData["data"]);
      List myData = await MyHelper().onlyGetMissingFiles(courseData["data"]);
      print(myData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionStateProvider>(
      builder: (context, mySession, child) => Scaffold(
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
              'Downloader',
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
        body: Column(children: [
          Text("Downloader"),
          if (isLoading) MyLoading(message: "Scanning NL Files"),
        ]),
      ),
    );
  }
}
