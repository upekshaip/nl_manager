import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MyPermissions {
  String nlManagerDir = "/storage/emulated/0/NLManager";

  Future<bool> checkPermissions() async {
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
      // openAppSettings(); // Direct user to app settings if permission is permanently denied
    }
    return false;
  }

  Future<String?> createFolder(String folderName) async {
    bool status = await checkPermissions();
    if (status == false) {
      return null;
    }
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
