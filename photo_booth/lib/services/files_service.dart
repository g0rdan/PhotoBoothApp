import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileService {

  Future<String> getTempDirectory() async {
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<String> getDocumentDirectory() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> createDocumentFolder(String name) async {
    if(name.isEmpty) {
      print('FileService.createDocumentFolder(): name of folder can\'t be null');
      return null;
    }

    var applicationFolder = await getDocumentDirectory();
    var path = join(applicationFolder, name); 
    return await Directory(path).create();
  }

  // gets list of files in partucular directory
  List<File> getFiles(String pathToDir) {
    if (pathToDir.isEmpty) {
      print('FilesService.getFilesInDirectory(): pathToDir can\'t be empty');
      return [];
    }
    List<File> files = [];
    var entries = Directory(pathToDir).listSync();
    for (var entry in entries) {
      if (entry is File)
        files.add(entry);
    }
    return files;
  }

  // gets list of directories in partucular directory
  List<Directory> getDirectories(String pathToDir) {
    if (pathToDir.isEmpty) {
      print('FilesService.getDirectories(): pathToDir can\'t be empty');
      return [];
    }
    List<Directory> folders = [];
    var entries = Directory(pathToDir).listSync();
    for (var entry in entries) {
      if (entry is Directory)
        folders.add(entry);
    }
    return folders;
  }

  // get particular file
  File getFile (String pathToFile) {
    if (pathToFile.isEmpty) {
      print('FilesService.getFile(): pathToFile can\'t be empty');
      return null;
    }
    try {
      return File(pathToFile);
    } catch (e) {
      print('FilesService.getFile() exception: $e');
      return null;
    }
  }

  Future<bool> saveInFile(String pathToFile, Uint8List bytes) async {
    if (pathToFile.isEmpty) {
      print('FilesService.saveInFile(): pathToFile can\'t be empty');
      return false;
    }
    if (bytes.isEmpty) {
      print('FilesService.saveInFile(): bytes can\'t be empty');
      return false;
    }
    try {
      var file = File(pathToFile);
      await file.writeAsBytes(bytes);
      return true;
    } catch (e) {
      print('FilesService.saveInFile() exception: $e');
      return false;
    }
  }
}