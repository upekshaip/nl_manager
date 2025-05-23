import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nlmanager/tasks/helpers.dart';

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
    Map<String, dynamic>? defaultValue = {
      "username": "",
      "password": "",
      "schedule": 6
    };
    Map<dynamic, dynamic>? userData =
        box.get("user_data", defaultValue: defaultValue);

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

  dynamic getAutoLogin() {
    var box = Hive.box('nlmanager');
    bool? myVal = box.get("auto_login");
    if (myVal != null) {
      Map<String, dynamic>? data = box.get("user_data");
      return data;
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
    // off
    if (autoLogin == false) {
      Map<String, dynamic> userData = {
        "username": "",
        "password": "",
        "schedule": 6
      };
      box.put("user_data", userData);
      MyHelper().cancelWorkManager();
    }
    // on
    if (autoLogin == true) {
      if (passwordController.text == "" || passwordController.text == "") {
        error = "Username and password are required";
        notifyListeners();
        return error;
      }
      Map<String, dynamic> userData = {
        "username": usernameController.text,
        "password": passwordController.text,
        "schedule": schedule
      };
      box.put("user_data", userData);
      MyHelper().startWorkManager(getSchedule());
    }
    box.put("auto_login", autoLogin);
    print("saved");
    return "Settings Saved!";
  }
}
//   }
//   return str;
