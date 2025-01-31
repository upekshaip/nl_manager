import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsStateProvider extends ChangeNotifier {
  late bool autoLogin = false; //off
  late int schedule = 6;
  late String error = "";
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SettingsStateProvider() {
    loadSettings();
  }

  void loadSettings() {
    var box = Hive.box('nlmanager');

    autoLogin = box.get("auto_login", defaultValue: false);
    Map<String, dynamic>? defaultValue = {"username": "", "password": "", "schedule": 6};
    Map<dynamic, dynamic>? userData = box.get("user_data", defaultValue: defaultValue);

    usernameController.text = userData!["username"];
    passwordController.text = userData["password"];
    schedule = userData["schedule"];

    notifyListeners();
  }

  void autoLoginChange(bool value) {
    autoLogin = value;
    error = "";
    if (!autoLogin) {
      usernameController.text = "";
      passwordController.text = "";
      schedule = 6;
    }
    notifyListeners();
  }

  int getSchedule() {
    var box = Hive.box('nlmanager');
    Map<String, dynamic>? myVal = box.get("user_data");
    if (myVal != null) {
      return myVal["schedule"];
    } else {
      return 6;
    }
  }

  bool getAutoLogin() {
    var box = Hive.box('nlmanager');
    bool? myVal = box.get("auto_login");
    if (myVal != null) {
      return myVal;
    } else {
      return false;
    }
  }

  void setSchedule(int value) {
    schedule = value;
    notifyListeners();
  }

  String saveChanges() {
    error = "";
    notifyListeners();
    var box = Hive.box('nlmanager');
    box.put("auto_login", autoLogin);
    // off
    if (autoLogin == false) {
      Map<String, dynamic> userData = {"username": "", "password": "", "schedule": 6};
      box.put("user_data", userData);
    }
    // on
    if (autoLogin == true) {
      if (passwordController.text == "" || passwordController.text == "") {
        error = "Username and password are required";
        notifyListeners();
        return error;
      }
      Map<String, dynamic> userData = {"username": passwordController.text, "password": passwordController.text, "schedule": schedule};
      box.put("user_data", userData);
    }
    print("saved");
    return "Settings Saved!";
  }
}
