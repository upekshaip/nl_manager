import 'package:flutter/material.dart';

class DownloadStateProvider extends ChangeNotifier {
  List<dynamic> needsToDownload = [];
  List<dynamic> downloaded = [];
  String status = "";
  String downloadingFileName = "";
  String downloadingFileSize = "";
  double totalProgress = 0.0;
  double currentProgress = 0.0;

  void setNeedsToDownload(List<dynamic> newNeedsToDownload) {
    needsToDownload = newNeedsToDownload;
    notifyListeners();
  }
}
