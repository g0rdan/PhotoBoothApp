import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart' as imagePicker;
import 'package:path/path.dart';
import 'package:photo_booth/models/photobooth_doc.dart';
import 'package:photo_booth/services/files_service.dart';
import 'package:photo_booth/services/photobooth_format_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:photo_booth/models/drawing_point.dart';

class MainModel extends Model {

  FileService _filesService;
  PhotoboothFormatService _phBoothService;

  GlobalKey canvasKey;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black,
    Colors.purple,
  ];
  List<DrawingPoint> _points = [];
  List<DrawingPoint> get points => _points;

  Size _canvasSize = Size(0, 0);
  Size get canvasSize => _canvasSize;
  set canvasSize (Size newSize) {
    if (newSize.width != _canvasSize.width || newSize.height != _canvasSize.height) {
      _canvasSize = newSize;
    }
  }

  CameraPreviewState _previewState = CameraPreviewState.empty;
  CameraPreviewState get previewState => _previewState;
  set previewState(CameraPreviewState newState) {
    // clear canvas if we're going to create a new one
    if (newState == CameraPreviewState.image)
      _points.clear();
    _previewState = newState;
    notifyListeners();
  }

  String _currentImagePath;
  String get currentImagePath => _currentImagePath;
  set currentImagePath(String path) {
    print(path);
    _currentImagePath = path;
  }

  Color _selectedColor = Colors.black;
  Color get selectedColor => _selectedColor;
  set selectedColor(Color newColor) {
    _selectedColor = newColor;
    notifyListeners();
  }

  bool _showColorsWidget = false;
  bool get showColorsWidget => _showColorsWidget;
  set showColorsWidget(bool newValue) {
    _showColorsWidget = newValue;
    notifyListeners();
  }

  List<DocumentItemModel> _documents = [];
  List<DocumentItemModel> get documents => _documents;
  set documents(List<DocumentItemModel> newDocuments) {
    _documents = newDocuments;
    notifyListeners();
  }

  MainModel(FileService filesService, PhotoboothFormatService phBoothService) {
    _filesService = filesService;
    _phBoothService = phBoothService;
  }

  Future<bool> saveAsPhotoboothDocument() async {
    return await _phBoothService.saveCanvasAsFile(
      currentImagePath, 
      DrawingArea()
        ..points = points
        ..size = canvasSize
    );
  }

  void addPoint(DrawingPoint point) {
    _points.add(point);
    notifyListeners();
  }

  void addDocument(String name, String pathToImage) {
    documents.add(DocumentItemModel(
      name: name, 
      pathToImage: pathToImage)
    );
    notifyListeners();
  }

  void undo() {
    if (_points.isEmpty)
      return;

    try {      
      do {
        if (_points.isNotEmpty)
          _points.removeLast();
      } while (_points.last != null);
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  void clear() {
    _points.clear();
    showColorsWidget = false;
    notifyListeners();
    previewState = CameraPreviewState.empty;
  }

  Future<void> getImage(imagePicker.ImageSource from) async {
    var image = await imagePicker.ImagePicker.pickImage(source: from);
    final bytes = image.readAsBytesSync();
    // place it in temp folder
    final tempDir = await _filesService.getTempDirectory();
    final path = join(tempDir, '${DateTime.now()}.png');
    var result = await _filesService.saveInFile(path, bytes);
    if (result) {
      currentImagePath = path;
      previewState = CameraPreviewState.image;
    }
    else {
      print('MainModel.getImage(): couldn\'t write file in temp folder');
    }
  }

  Future<bool> saveToGallery(ImageFormat imageFormat) async {
    // if canvas is empty there is nothing to save
    if (canvasKey == null)
      return false;

    switch (imageFormat) {
      case ImageFormat.png:
        return await _savePng(canvasKey);
      default:
        return false;
    }
  }

  Future<bool> _savePng(GlobalKey key) async {
    try {
      // finding canvas of the widget
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      // transform the canvas into image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      // convert the image into png
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      // transfering png as sequence of bytes
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // making temp file
      final tempDir = await _filesService.getTempDirectory();
      final path = join(tempDir, 'canvas_${DateTime.now()}.png');
      // write bytes into the file
      bool result = await _filesService.saveInFile(path, pngBytes);
      if (result)
        // saving temp file into OS gallery
        return await GallerySaver.saveImage(path);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<DocumentItemModel>> getDocuments() async {
    try {
      documents.clear();
      var docDirectory = await _filesService.getDocumentDirectory();
      var dirs = _filesService.getDirectories(docDirectory);
      for (var dir in dirs) {
        var name = basename(dir.path);
        var pathToImage = join(dir.path, '$name.png');
        documents.add(DocumentItemModel(
          name: name, 
          pathToImage: pathToImage)
        );
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return documents;
  }

  Future<void> placeDocumentOnCanvas(DocumentItemModel model) async {
    currentImagePath = model.pathToImage;
    previewState = CameraPreviewState.image;

    var docFolder = await _filesService.getDocumentDirectory();
    var pathToJson = join(docFolder, model.name, '${model.name}.json');
    var file = await File(pathToJson).readAsString();
    var doc = PhotoboothPencilDocument.fromJson(json.decode(file));
    var drawingArea = _phBoothService.toDrawingPoints(doc);
    points.clear();
    _points = drawingArea.points;
    notifyListeners();
  }
}

class DocumentItemModel {
  String name;
  String pathToImage;
  DocumentItemModel({this.name, this.pathToImage});
}

enum CameraPreviewState { empty, image }
enum ImageFormat { png, jpeg, photobooth }
enum SourceOfImage { fromCamera, fromGallery, fromDocuments }