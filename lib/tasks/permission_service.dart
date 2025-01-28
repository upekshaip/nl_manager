import 'package:permission_handler/permission_handler.dart';

class MyPermissions {
  Future<bool> checkPermissions() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return false;
      // openAppSettings(); // Direct user to app settings if permission is permanently denied
    }
    return false;
  }
}
