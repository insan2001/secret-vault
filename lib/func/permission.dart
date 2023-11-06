import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  PermissionStatus image = await Permission.photos.request();
  PermissionStatus video = await Permission.videos.request();
  PermissionStatus manage = await Permission.manageExternalStorage.request();

  if (image.isGranted && video.isGranted && manage.isGranted) {
    return true;
  } else {
    return false;
  }
}
