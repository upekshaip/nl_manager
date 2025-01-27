import 'package:flutter/material.dart';
import 'package:http_session/http_session.dart';

class SessionStateProvider extends ChangeNotifier {
  HttpSession session = HttpSession();
  String username = "";
  String password = "";
  Map<String, Object?> tokens = {};
  List<dynamic> courseData = [];

  HttpSession getMySession() {
    return session;
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

  void setUser(String newUsername, String newPassword) {
    username = newUsername;
    password = newPassword;
    notifyListeners();
  }
}
