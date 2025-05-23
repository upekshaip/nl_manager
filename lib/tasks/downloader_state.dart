import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/permission_service.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:http/http.dart' as http;

class DownloadStateProvider extends ChangeNotifier {
  List<dynamic> needsToDownload = [];
  List<dynamic> downloaded = [];
  String statusMessage = "";
  // quick access to the current downloading file
  String downloadingFileName = "";
  String downloadingFilePath = "";
  String downloadingFileUrl = "";

  int downloadingFileSize = 0;
  int downloadingFileDownloaded = 0;

  double totalProgress = 0.0;
  double currentProgress = 0.0;

  bool isProcessing = false;
  bool isDownloading = false;

  bool problems = false;

  void setNeedsToDownload(List<dynamic> newNeedsToDownload) {
    needsToDownload = newNeedsToDownload;
    notifyListeners();
  }

  Future getMissingFiles(SessionStateProvider mySession, CourseStateProvider myCourse) async {
    resetValues();
    isProcessing = true;
    statusMessage = "Scanning NL Files...";
    notifyListeners();
    await myCourse.refresh(mySession);
    List missingFiles = await MyHelper().onlyGetMissingFiles(myCourse.courseData);
    setNeedsToDownload(missingFiles);
    isProcessing = false;
    statusMessage = "Press the download button to start downloading.";
    notifyListeners();
  }

  Future startDownload(SessionStateProvider mySession) async {
    isDownloading = true;
    statusMessage = "Downloading...";
    notifyListeners();

    for (var file in needsToDownload) {
      try {
        problems = false;
        downloadingFileName = "${file['file_name']}.${file['ext']}";
        downloadingFilePath = "NLManager/${file['path']}";
        downloadingFileUrl = file['url'];

        // downloading code...
        final request = http.Request("GET", Uri.parse(file['url']));
        final streamedResponse = await mySession.session.send(request);
        final newFile = File('/storage/emulated/0/NLManager/${file["path"]}');
        var withoutFile = '${file['path'].split("/")[0]}/${file['path'].split("/")[1]}';
        await MyPermissions().createFolder(withoutFile);
        downloadingFileSize = 0;
        downloadingFileDownloaded = 0;
        notifyListeners();

        if (streamedResponse.statusCode == 200) {
          statusMessage = "Downloading...";
          downloadingFileSize = streamedResponse.contentLength!;
          notifyListeners();
          // Stream and write to file
          List<int> bytes = [];
          streamedResponse.stream.listen(
            (List<int> chunk) {
              bytes.addAll(chunk);
              downloadingFileDownloaded += chunk.length;
              currentProgress = (downloadingFileDownloaded.toDouble() / streamedResponse.contentLength!);
              notifyListeners();
            },
            onDone: () async {
              await newFile.writeAsBytes(bytes);
              file["d_status"] = "complete";
              downloaded.add(file);

              totalProgress = needsToDownload.isEmpty ? 1 : (downloaded.length / needsToDownload.length);

              statusMessage = "Download complete. ✅";
              notifyListeners();
            },
            onError: (e) {
              problems = true;
              statusMessage = "Download error: $e";
              notifyListeners();
            },
            cancelOnError: true,
          );
          await MyHelper().showProgressNotification(title: "📥 Downloading NLearn Files...", progress: totalProgress * 100);
        } else {
          downloadingFileSize = 0;
          problems = true;
        }
        notifyListeners();
      } catch (e) {
        statusMessage = "Download error: $e";
        problems = true;
        notifyListeners();
        print(e);
      }
    }

    await MyHelper().showNotification(title: "Download Complete ✅", body: "Your files have been downloaded successfully! Make sure to refresh again to see the latest updates.");
    // after downloading code...
    resetValues();
    notifyListeners();
  }

  void resetValues() {
    needsToDownload = [];
    downloaded = [];
    statusMessage = "";
    // quick access to the current downloading file
    downloadingFileName = "";
    downloadingFilePath = "";
    downloadingFileUrl = "";

    downloadingFileSize = 0;
    downloadingFileDownloaded = 0;

    totalProgress = 0.0;
    currentProgress = 0.0;

    isProcessing = false;
    isDownloading = false;
    notifyListeners();
  }

  void clearData() {
    resetValues();
    problems = false;
    // downloading code...
  }
}