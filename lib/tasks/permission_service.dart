import 'dart:io';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MyPermissions {
  String nlManagerDir = "/storage/emulated/0/NLManager";

  Future<bool> checkPermissions() async {
    bool storage = await checkStoragePermission();
    bool notifications = await checkNotificationPermission();
    if (storage && notifications) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkNotificationPermission() async {
    // method 1 - problem is it navigates to /downloader
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //     return false;
    //   }
    // });
    // return true;
    // method 2
    var notify = await Permission.notification.request();
    if (notify == PermissionStatus.granted) {
      return true;
    } else if (notify == PermissionStatus.denied) {
      return false;
    } else if (notify == PermissionStatus.permanentlyDenied) {
      return false;
    }
    return false;
  }

  Future<bool> checkStoragePermission() async {
    var plugin = DeviceInfoPlugin();
    var android = await plugin.androidInfo;
    var storageStatus = android.version.sdkInt < 33 ? await Permission.storage.request() : PermissionStatus.granted;
    var externalStorageStatus = android.version.sdkInt < 33 ? PermissionStatus.granted : await Permission.manageExternalStorage.request();
    if (storageStatus == PermissionStatus.granted && externalStorageStatus == PermissionStatus.granted) {
      return true;
    } else if (storageStatus == PermissionStatus.denied || externalStorageStatus == PermissionStatus.denied) {
      return false;
    } else if (storageStatus == PermissionStatus.permanentlyDenied || externalStorageStatus == PermissionStatus.permanentlyDenied) {
      return false;
    }
    return false;
  }

  Future<String?> createFolder(String folderName) async {
    Directory folder = Directory("$nlManagerDir/$folderName");
    if (!await folder.exists()) {
      folder.create(recursive: true);
    }
    return folder.path;
  }

  Future<List<FileSystemEntity>> getFiles() async {
    Directory nlManager = Directory(nlManagerDir);
    if (await nlManager.exists()) {
      List<FileSystemEntity> filesAndFolders = nlManager.listSync(recursive: true);
      return filesAndFolders.whereType<File>().toList();
      // return filesAndFolders;
    } else {
      return [];
    }
  }
}
