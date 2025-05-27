import 'dart:convert';
import 'package:http_session/http_session.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:nlmanager/tasks/helpers.dart';

class Course {
  final Map<String, String?> tokens;
  final HttpSession session;
  final int reverseDays;
  String getCourseUrl = "https://nlearn.nsbm.ac.lk/lib/ajax/service.php?info=core_course_get_enrolled_courses_by_timeline_classification&sesskey=";
  String todoDataUrl = "https://nlearn.nsbm.ac.lk/lib/ajax/service.php?info=core_calendar_get_action_events_by_timesort&sesskey=";

  Course({required this.tokens, required this.session, required this.reverseDays});

  Future<Map<String, dynamic>> getTodos() async {
    try {
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
      var todoRes = await session.post(Uri.parse(todoDataUrl + tokens['sesskey']!), body: jsonEncode(todoJsonData));

      var todoData = jsonDecode(todoRes.body);
      if (todoData[0]["error"] == true) {
        throw Exception("Failed to get courses");
      }

      // filter out
      var myData = todoData[0]["data"]["events"];

      List<dynamic> filtered = [];
      for (var item in myData) {
        var temp = item["course"];
        temp.remove("courseimage");
        var others = item;
        others.remove("course");
        var deadline = parse(others["formattedtime"]).querySelector("a");
        filtered.add({"course": temp, "others": others, "deadline": "${deadline!.text}, ${others["formattedtime"].split(",")[2].toString().replaceAll('</span>', '')}"});
      }

      return {"todos": filtered};
    } catch (e) {
      // print(e);
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCourses() async {
    try {
      var courseJsonData = [
        {
          "index": 0,
          "methodname": "core_course_get_enrolled_courses_by_timeline_classification",
          "args": {"offset": 0, "limit": 0, "classification": "all", "sort": "fullname", "customfieldname": "", "customfieldvalue": ""}
        }
      ];

      var courseRes = await session.post(Uri.parse(getCourseUrl + tokens['sesskey']!), body: jsonEncode(courseJsonData));

      var courseData = jsonDecode(courseRes.body);
      if (courseData[0]["error"] == true) {
        throw Exception("Failed to get courses");
      }
      // filter out course image
      var myData = courseData[0]["data"]["courses"];
      List<dynamic> filteredData = myData.map((course) {
        course.remove("courseimage");
        course["contents"] = [];
        return course;
      }).toList();

      return {"courses": filteredData};
    } catch (e) {
      // print(e);
      return {"error": e.toString()};
    }
  }

  String rmKeys(String str) {
    var keys = ["\\", "/", ":", "*", "?", "\"", "^", ">", "<", "|", "\n", "\t"];
    if (str.contains("\\") || str.contains("/")) {
      str = str.replaceAll("/", "or");
      str = str.replaceAll("\\", "or");
    }
    for (var key in keys) {
      if (str.contains(key)) {
        str = str.replaceAll(key, "").trim();
      }
    }
    if (str.length > 250) {
      str = str.substring(0, 250);
    }
    return str.trim();
  }

  Future<List<dynamic>?> getAllCourseInfo(List<dynamic> data) async {
    // inside the course (TODO: get all course content at onece and then filter)
    int count = 0;
    try {
      for (var course in data) {
        var couseRes = await session.get(Uri.parse(course["viewurl"]));
        if (couseRes.statusCode != 200) {
          return null;
        }
        // notification
        count += 1;
        double progress = (data.isEmpty) ? 0 : count / data.length;
        await MyHelper().showProgressNotification(title: "🔍 Scanning NLearn Files...", progress: progress * 100);

        var doc = parse(couseRes.body);
        List<Element> courseContent = doc.querySelectorAll('.content');
        if (courseContent.isNotEmpty) {
          courseContent.removeLast();
        }

        // inside the course content (section)
        var myCourse = [];
        for (var section in courseContent) {
          var topic = section.querySelector('.sectionname')!.querySelector("span")!.text;
          topic = rmKeys(topic);
          var sections = section.querySelectorAll(".activityinstance");

          var sectionData = {"section_name": topic, "section_content": []};
          for (var files in sections) {
            if (files.querySelector("a") != null) {
              var fileName = files.querySelector("a")!.querySelector(".instancename")!.text;
              String fileType = "not sure";
              if (files.querySelector("a .instancename span") != null) {
                fileType = files.querySelector("a .instancename span")!.text.trim();
              }
              if (fileType == "not sure" && files.querySelector("a .instancename")!.text.isNotEmpty) {
                // print("flag - quote file type inside data");
                fileType = files.querySelector("a .instancename")!.text.trim();
              }
              var fileUrl = files.querySelector("a")!.attributes["href"];
              var fileImage = files.querySelector("a img")?.attributes["src"];
              var ext = getExt(fileImage!);

              // print("$fileType - $ext");
              Map<String, String?> fileData;
              String myPath = '${course["fullname"]}/$topic/${rmKeys(fileName)}.$ext';
              if (fileType == "File") {
                fileData = {"file_name": rmKeys(fileName), "file_type": fileType, "url": fileUrl, "image": fileImage, "ext": ext, "path": myPath};
              } else if (fileType == "Folder") {
                var folderId = fileUrl!.split("=")[1];
                var folderUrl = "https://nlearn.nsbm.ac.lk/mod/folder/download_folder.php?id=$folderId&sesskey=${tokens['sesskey']}";
                fileData = {"file_name": rmKeys(fileName), "file_type": fileType, "url": folderUrl, "image": fileImage, "ext": ext, "path": myPath};
              } else {
                fileData = {"file_name": fileName, "file_type": fileType, "url": fileUrl, "image": fileImage, "ext": ext};
              }
              (sectionData["section_content"] as List).add(fileData);
            }
          }
          myCourse.add(sectionData);
        }
        course["contents"] = myCourse;
      }
      await MyHelper().showNotification(title: "🔍 Scan Completed", body: "Successfully scanned all courses. ✅");
      return data;
    } catch (e) {
      // print(e);
      return null;
    }
  }
}
