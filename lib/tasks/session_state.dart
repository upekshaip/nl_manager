import 'package:flutter/material.dart';
import 'package:http_session/http_session.dart';

class SessionStateProvider extends ChangeNotifier {
  late HttpSession session;
  String username = "";
  String password = "";
  Map<String, Object?> tokens = {};
  List<dynamic> courseData = [];
  List<dynamic> todos = [];

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

  void setCourseData(List<dynamic> newCourseData) {
    courseData = newCourseData;
    notifyListeners();
  }

  void setTodos(List<dynamic> newTodos) {
    todos = newTodos;
    notifyListeners();
  }

  void setUser(String newUsername, String newPassword) {
    username = newUsername;
    password = newPassword;
    notifyListeners();
  }

  void logOut() {
    session.clear();
    session.close();
    tokens = {};
    courseData = [];
    notifyListeners();
  }
}
