import 'dart:io';
import 'dart:typed_data';

import 'package:photo_booth/models/drawing_point.dart';
import 'package:photo_booth/models/photobooth_doc.dart';
import 'package:photo_booth/services/files_service.dart';
import 'package:photo_booth/services/image_service.dart';
import 'package:photo_booth/services/photobooth_service.dart';

class PhotoboothServiceMock implements IPhotoboothService {
  @override
  Future<bool> saveCanvasAsFile(String pathToImage, DrawingArea canvas) {
    return Future(() {
      return true;
    });
  }

  @override
  DrawingArea toDrawingPoints(PhotoboothDocument document) {
    return DrawingArea.createMock();
  }

  @override
  PhotoboothDocument toPhotoboothFormat(DrawingArea canvas) {
    return PhotoboothDocument.createMock();
  }
}

class ImageServiceMock implements IImageService {
  @override
  Future<Uint8List> getImageFromCamera() {
    return Future((){
      return Uint8List.fromList([0, 1, 2]);
    });
  }

  @override
  Future<Uint8List> getImageFromGallery() {
    return Future((){
      return Uint8List.fromList([0, 1, 2]);
    });
  }

  @override
  Future<bool> saveImageInGallery(String path) {
    return Future((){
      return true;
    });
  }
}

class FileServiceMock implements IFileService {
  @override
  String basename(String path) {
    return "base name";
  }

  @override
  Future<Directory> createDocumentFolder(String name) {
    return Future((){
      return Directory("/path/to/document/folder");
    }); 
  }

  @override
  List<Directory> getDirectories(String pathToDir) {
    return [
      Directory('one'),
      Directory('two')
    ];
  }

  @override
  File getFile(String pathToFile) {
    return File(pathToFile);
  }

  @override
  List<File> getFiles(String pathToDir) {
    return [
      File('first'),
      File('second')
    ];
  }

  @override
  Future<String> getTempDirectory() {
    return Future((){
      return 'path/to/temp/folder';
    });
  }

  @override
  String join(String part1, String part2, [String part3]) {
    return part1 + part2 + (part3 != null ? part3 : '');
  }

  @override
  Future<bool> saveInFile(String pathToFile, Uint8List bytes) {
    return Future((){
      return true;
    });
  }

  @override
  Future<String> getDocumentDirectory() {
    return Future((){
      return 'path/to/app/home/directory';
    });
  }

  @override
  Future<Uint8List> readFileAsBytes(String pathToFile) {
    return Future((){
      return Uint8List.fromList(List<int>());
    });
  }

  @override
  Future<String> readFileAsString(String pathToFile) {
    return Future((){
      return 'file content';
    });
  }
}