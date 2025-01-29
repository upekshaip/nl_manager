import 'package:flutter/material.dart';
import 'package:http_session/http_session.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/login_task.dart';

class SessionStateProvider extends ChangeNotifier {
  late HttpSession session;
  String username = "";
  String password = "";
  Map<String, Object?> tokens = {};

  // login
  String loginStatus = "";
  bool isLoginLoading = false;

  HttpSession getMySession() {
    return session;
  }

  void startNewSession() {
    session = HttpSession();
    notifyListeners();
  }

  void setMySession(HttpSession newSession) {
    session = newSession;
    notifyListeners();
  }

  void setTokens(Map<String, Object?> newTokens) {
    tokens = newTokens;
    notifyListeners();
  }

  void setUser(String newUsername, String newPassword) {
    username = newUsername;
    password = newPassword;
    notifyListeners();
  }

  void logOut(CourseStateProvider myCourse) {
    session.clear();
    session.close();
    tokens = {};
    username = "";
    password = "";
    myCourse.clearCourseData();
    notifyListeners();
  }

  Future<bool> login(CourseStateProvider myCourse, String username, String password) async {
    bool isLogin = false;
    if (username.isEmpty || password.isEmpty) {
      loginStatus = "Please enter username and password";
      isLoginLoading = false;
      notifyListeners();
      return isLogin;
    }
    isLoginLoading = true;
    notifyListeners();

    startNewSession();
    HttpSession session = getMySession();
    var myLogin = Login(username: username, password: password, session: session);
    var tokens = await myLogin.getToken();
    if (tokens!.containsKey("error")) {
      loginStatus = tokens["error"]!;
      isLoginLoading = false;
    }
    if (tokens.containsKey("cookie")) {
      setTokens(tokens);
      setUser(username, password);
      loginStatus = "";
      isLoginLoading = false;
      isLogin = true;
    }
    myCourse.refreshTodos(this);
    notifyListeners();
    return isLogin;
  }
}
