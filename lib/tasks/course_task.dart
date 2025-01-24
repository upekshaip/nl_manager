// import 'package:html/parser.dart' show parse;
import 'dart:convert';

import 'package:http_session/http_session.dart';

class Course {
  final Map<String, String?> tokens;
  final HttpSession session;
  final int reverseDays;
  String getCourseUrl = "https://nlearn.nsbm.ac.lk/lib/ajax/service.php?info=core_course_get_enrolled_courses_by_timeline_classification&sesskey=";
  String todoDataUrl = "https://nlearn.nsbm.ac.lk/lib/ajax/service.php?info=core_calendar_get_action_events_by_timesort&sesskey=";

  Course({required this.tokens, required this.session, required this.reverseDays});

  Future<Map<String, dynamic>?> getCourses() async {
    print("Getting courses...");
    try {
      var courseJsonData = [
        {
          "index": 0,
          "methodname": "core_course_get_enrolled_courses_by_timeline_classification",
          "args": {"offset": 0, "limit": 0, "classification": "all", "sort": "fullname", "customfieldname": "", "customfieldvalue": ""}
        }
      ];

      // get time
      var now = DateTime.now();
      var oneYearAgo = now.subtract(Duration(days: reverseDays));
      var oneYearAgoTimestamp = oneYearAgo.millisecondsSinceEpoch ~/ 1000;

      var todoJsonData = [
        {
          "index": 0,
          "methodname": "core_calendar_get_action_events_by_timesort",
          "args": {"limitnum": 26, "timesortfrom": oneYearAgoTimestamp, "limittononsuspendedevents": true}
        }
      ];

      var courseRes = await session.post(Uri.parse(getCourseUrl + tokens['sesskey']!), body: jsonEncode(courseJsonData));
      var todoRes = await session.post(Uri.parse(todoDataUrl + tokens['sesskey']!), body: jsonEncode(todoJsonData));

      // print("Course Response: ${courseRes.body}");
      var todoData = jsonDecode(todoRes.body);
      var courseData = jsonDecode(courseRes.body);
      if (todoData[0]["error"] == true) {
        throw Exception("Failed to get courses");
      }
      if (courseData[0]["error"] == true) {
        throw Exception("Failed to get courses");
      }

      return {"courses": courseData, "todos": todoData};
    } catch (e) {
      print(e);
      return null;
    }
  }
}
