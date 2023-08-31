import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<List<File>> pickImage() async {
  List<File> images = [];
  var files = await FilePicker.platform
      .pickFiles(type: FileType.image, allowMultiple: true);
  if (files != null && files.files.isNotEmpty) {
    for (int i = 0; i < files.files.length; i++) {
      images.add(File(files.files[i].path!));
    }
  }
  return images;
}
