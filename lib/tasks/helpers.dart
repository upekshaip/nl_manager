import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHelper {
  Icon getIcons(String ext, String url) {
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
          content: Text('This app needs storage permission to continue.', style: TextStyle(color: Colors.grey.shade300)),
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
                } else if (status.isPermanentlyDenied) {
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
}
