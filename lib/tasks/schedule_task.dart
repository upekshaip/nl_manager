import 'package:hive_flutter/hive_flutter.dart';
import 'package:http_session/http_session.dart';
import 'package:nlmanager/tasks/course_task.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/login_task.dart';

class ScheduleTask {
  Future<void> run() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('nlmanager');
    bool autoLogin = box.get("auto_login", defaultValue: false);

    if (!autoLogin) {
      Hive.close();
      MyHelper().scheduledNotification(
          title: "🔒 Auto login is off",
          body: "Please enable auto login in settings ⚙️");
      return;
    }
    Map<String, dynamic>? defaultValue = {
      "username": "",
      "password": "",
      "schedule": 6
    };
    Map<dynamic, dynamic>? userData =
        box.get("user_data", defaultValue: defaultValue);
    String username = userData!["username"];
    String password = userData["password"];
    // print("=======================================================");
    // print("$username, $password");
    // print("=======================================================");
    Hive.close();
    if (username.isEmpty || password.isEmpty) {
      MyHelper().scheduledNotification(
          title: "❌ Auto login failed",
          body: "Username or password is empty 🔑");
      return;
    }

    // login
    var session = HttpSession();
    Login myLogin =
        Login(username: username, password: password, session: session);
    var tokens = await myLogin.getToken();
    if (tokens!.containsKey("error")) {
      MyHelper().scheduledNotification(
          title: "❌ Auto login failed", body: tokens["error"]!);
      return;
    }
    if (tokens.containsKey("cookie")) {
      MyHelper().scheduledNotification(
          title: "✅ Auto login success 🎉",
          body: "Welcome ${tokens["username"]} 👋");
    }
    Course myCourse = Course(tokens: tokens, session: session, reverseDays: 15);
    Map<String, dynamic> courseData = await myCourse.getAllCourses();
    Map<String, dynamic> todos = await myCourse.getTodos(); //todos
    session.clear();
    session.close();

    if (courseData.containsKey("error") || todos.containsKey("error")) {
      MyHelper().scheduledNotification(
          title: "❗️ Error occurred",
          body: "Failed to get courses or todos 📚");
      return;
    }
    List missingFiles =
        await MyHelper().onlyGetMissingFiles(courseData["data"]);

    String subTitle =
        "📂 Missing files: ${missingFiles.length} | 📝 Todos: ${todos["todos"].length}";
    String title = "✅ You are up to date 🎉";
    if (missingFiles.isNotEmpty) {
      title = "❗️ You have ${missingFiles.length} missing files 📂";
    }
    MyHelper().scheduledNotification(title: title, body: subTitle);
  }
}
