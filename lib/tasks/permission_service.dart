import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MyPermissions {
  Future<bool> checkPermissions() async {
    var plugin = DeviceInfoPlugin();
    var android = await plugin.androidInfo;
    var storageStatus = android.version.sdkInt < 33 ? await Permission.storage.request() : PermissionStatus.granted;
    if (storageStatus == PermissionStatus.granted) {
      return true;
    } else if (storageStatus == PermissionStatus.denied) {
      return false;
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      return false;
      // openAppSettings(); // Direct user to app settings if permission is permanently denied
    }
    return false;
  }
}
