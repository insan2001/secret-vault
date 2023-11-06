import 'dart:io';

import 'package:file_hider/func/imageList.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<List<FileSystemEntity>> unlockDocument(String path) async {
  File myFile = File(path);

  await ImageGallerySaver.saveFile(path).then((value) {
    myFile.deleteSync();
  });
  return await myImageList();
}
