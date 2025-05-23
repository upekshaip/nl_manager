import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:nlmanager/tasks/permission_service.dart';
import 'package:nlmanager/tasks/schedule_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class MyHelper {
  Icon getIcons(String ext, String url, {String? state = ""}) {
    if (state == "complete") {
      return Icon(Icons.check, color: Colors.green.shade500);
    }

    IconData icon = Icons.question_mark;
    Color color = Colors.grey.shade300;

    if (ext != "unknown") {
      if (ext == "txt") {
        icon = Icons.text_snippet;
        color = Colors.grey.shade300;
      }
      if (ext == "pdf") {
        icon = Icons.picture_as_pdf;
        color = Colors.red.shade400;
      }
      if (ext == "pptx") {
        icon = Icons.slideshow;
        color = Colors.orange.shade700;
      }
      if (ext == "docx") {
        icon = Icons.description;
        color = Colors.blue.shade400;
      }
      if (ext == "xlsx") {
        icon = Icons.table_chart;
        color = Colors.green.shade400;
      }
      if (ext == "mpeg") {
        icon = Icons.play_circle;
        color = Colors.purple.shade300;
      }
      if (ext == "zip") {
        icon = Icons.folder_zip;
        color = Colors.yellow.shade300;
      }
    } else {
      if (url.contains("assign")) {
        icon = Icons.assignment_add;
        color = Colors.blue.shade800;
      }
      if (url.contains("forum")) {
        icon = Icons.forum;
        color = Colors.purple.shade300;
      }
      if (url.contains("url")) {
        icon = Icons.link;
        color = Colors.grey.shade300;
      }
      if (url.contains("quiz")) {
        icon = Icons.quiz;
        color = Colors.pink.shade300;
      }
      if (url.contains("choicegroup")) {
        icon = Icons.checklist;
        color = Colors.purple.shade700;
      }
    }
    return Icon(icon, color: color);
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          title: Text('Permission Required', style: TextStyle(color: Colors.grey.shade200)),
          content: Text('This app needs storage and notification permission to continue.', style: TextStyle(color: Colors.grey.shade300)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var status = await Permission.storage.request();
                if (status.isGranted) {
                  Navigator.pushNamed(context, '/modules');
                } else if (status.isPermanentlyDenied || status.isDenied) {
                  openAppSettings();
                }
              },
              child: Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  Future<List> onlyGetMissingFiles(List courseData) async {
    var temp = [];
    List<FileSystemEntity> existingFiles = await MyPermissions().getFiles();
    for (var course in courseData) {
      for (var section in course["contents"]) {
        for (var file in section["section_content"]) {
          if (file.containsKey("file_type") && (file["file_type"] == "File" || file["file_type"] == "Folder")) {
            // temp.add(file["file_type"]);
            bool fileExists = existingFiles.any((item) => item.path == '/storage/emulated/0/NLManager/${file["path"]}');
            if (!fileExists) {
              file["d_state"] = "pending";
              temp.add(file);
            }
          }
        }
      }
    }
    return temp;
  }

  String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const List<String> suffixes = ["B", "KB", "MB", "GB", "TB", "PB"];
    int i = (bytes > 0) ? (bytes ~/ 1024).toString().length ~/ 3 : 0;
    double size = bytes / (1 << (i * 10));
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

// normal notifications
  Future<void> showProgressNotification({required String title, required double progress}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'NLManager',
        title: title,
        body: 'Progress: ${progress.toStringAsFixed(2)}% ⚡️',
        notificationLayout: NotificationLayout.ProgressBar,
        progress: progress, // Updates the progress bar dynamically
        locked: true, // Prevents user from swiping the notification away
      ),
    );
  }

  Future<void> showNotification({required String title, required String body}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'NLManager',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        locked: false, // Allow user to dismiss the notification
      ),
    );
  }

  // scheduled notifications
  Future<void> scheduledProgressNotification({required String title, required double progress}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'NLManager_auto',
        title: title,
        body: 'Progress: ${progress.toStringAsFixed(2)}% ⚡️',
        notificationLayout: NotificationLayout.ProgressBar,
        progress: progress, // Updates the progress bar dynamically
        locked: true, // Prevents user from swiping the notification away
      ),
    );
  }

  Future<void> scheduledNotification({required String title, required String body}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'NLManager_auto',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        locked: false, // Allow user to dismiss the notification
      ),
    );
  }

// workmanager

  void startWorkManager(int hours) {
    var duration = Duration(hours: 6);
    if (hours == 15 || hours == 30) {
      duration = Duration(minutes: hours);
    } else {
      duration = Duration(hours: hours);
    }
    cancelWorkManager();
    Workmanager().registerPeriodicTask(
      "NLManager_automate",
      "send_notifications",
      frequency: duration,
    );
  }

  void cancelWorkManager() {
    Workmanager().cancelByUniqueName("NLManager_automate");
  }

// workmanager callback (MAJOR)
  void callbackDispatcher() async {
    Workmanager().executeTask((task, inputData) async {
      MyHelper().scheduledNotification(title: "⏰ Scheduled Scan Started!", body: "Scanning for missing files and todos...");
      await ScheduleTask().run();
      return Future.value(true);
    });
  }
}
  String rmKeys(String text) {
    return text.replaceAll(RegExp(r'[\[\]{}]'), '');
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