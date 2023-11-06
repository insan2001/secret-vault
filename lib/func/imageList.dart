// ignore_for_file: file_names

import 'dart:io';

import 'package:file_hider/main.dart';

Future<List<FileSystemEntity>> myImageList() async {
  List<FileSystemEntity> hiddenFiles = await hidden.list().toList();

  return hiddenFiles;
}
