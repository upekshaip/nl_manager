import 'package:flutter/material.dart';
import 'package:nlmanager/tasks/course_task.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/session_state.dart';

class CourseStateProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = "";
  List<dynamic> courseData = [];
  List<dynamic> todos = [];
  bool isTodosLoading = false;
  String todosError = "";

  void refreshTodos(SessionStateProvider mySession) async {
    todosError = "";
    isTodosLoading = true;
    notifyListeners();

    final course = Course(tokens: mySession.tokens.cast<String, String?>(), session: mySession.getMySession(), reverseDays: 15);
    var todos = await course.getTodos();
    if (todos.containsKey("error")) {
      todosError = todos["error"];
      isTodosLoading = false;
      notifyListeners();
      return;
    }
    isTodosLoading = false;
    todosError = "";
    setTodos(todos["todos"]);
  }

  Future refresh(SessionStateProvider mySession) async {
    error = "";
    isLoading = true;
    notifyListeners();

    final course = Course(tokens: mySession.tokens.cast<String, String?>(), session: mySession.session, reverseDays: 15);
    Map<String, dynamic> courseData = await course.getAllCourses();
    if (courseData.containsKey("error")) {
      error = courseData["error"];
      isLoading = false;
      notifyListeners();
      return;
    }
    isLoading = false;
    error = "";
    setCourseData(courseData["data"]);
  }

  void setCourseData(List<dynamic> newCourseData) {
    courseData = newCourseData;
    notifyListeners();
  }

  void setTodos(List<dynamic> newTodos) {
    todos = newTodos;
    notifyListeners();
  }

  void clearCourseData() {
    courseData = [];
    todos = [];
    notifyListeners();
  }
}
