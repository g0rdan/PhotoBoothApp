import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as pathlib;
import 'package:path_provider/path_provider.dart';

/// The service provides functions for reading 
/// and writing files and direcrories of the application
class FileService implements IFileService {
  /// Return combined path
  String join(String part1, String part2, [String part3]) {
    if (part3 == null) {
      return pathlib.join(part1, part2);
    }
    else {
      return pathlib.join(part1, part2, part3);
    }
  }
  /// Returns the last name of the file or directory from path
  String basename(String path){
    return pathlib.basename(path);
  }
  /// Returns path to temp folder in OS
  /// 
  /// On iOS, this uses the 'NSCachesDirectory' API.
  /// On Android, this uses the 'getCacheDir' API on the context.
  Future<String> getTempDirectory() async {
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  /// Returns path to app document directory
  /// 
  /// On iOS, this uses the 'NSDocumentDirectory',
  /// On Android, this uses the 'getDataDirectory'
  Future<String> getDocumentDirectory() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Creates folder in app document directory using [name]
  Future<Directory> createDocumentFolder(String name) async {
    if(name.isEmpty) {
      print('FileService.createDocumentFolder(): name of folder can\'t be null');
      return null;
    }
    var applicationFolder = await getDocumentDirectory();
    var path = join(applicationFolder, name); 
    return await Directory(path).create();
  }

  /// Gets list of files in [pathToDir]
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

  /// Gets list of directories in [pathToDir]
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

  /// Get particular file using [pathToFile]
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

  /// Saves [bytes] data into file by [pathToFile]
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

  Future<String> readFileAsString(String pathToFile) async {
    try {
      return await File(pathToFile).readAsString();
    }
    catch (e) {
      print(e);
      return '';
    }
  }

  Future<Uint8List> readFileAsBytes(String pathToFile) async {
    try {
      return await File(pathToFile).readAsBytes();
    }
    catch (e) {
      print(e);
      return Uint8List.fromList(List<int>());
    }
  }
}

abstract class IFileService {
  String join(String part1, String part2, [String part3]);
  String basename(String path);
  Future<String> getTempDirectory();
  Future<String> getDocumentDirectory();
  Future<Directory> createDocumentFolder(String name);
  List<File> getFiles(String pathToDir);
  List<Directory> getDirectories(String pathToDir);
  File getFile (String pathToFile);
  Future<bool> saveInFile(String pathToFile, Uint8List bytes);
  Future<String> readFileAsString(String pathToFile);
  Future<Uint8List> readFileAsBytes(String pathToFile);
}