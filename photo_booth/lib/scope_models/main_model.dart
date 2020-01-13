import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:photo_booth/models/photobooth_doc.dart';
import 'package:photo_booth/services/files_service.dart';
import 'package:photo_booth/services/photobooth_service.dart';
import 'package:photo_booth/services/image_service.dart';
import 'package:photo_booth/models/drawing_point.dart';

class MainModel extends Model {

  IFileService _filesService;
  IImageService _imageService;
  IPhotoboothService _phBoothService;

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

  PreviewState _previewState = PreviewState.empty;
  PreviewState get previewState => _previewState;
  set previewState(PreviewState newState) {
    // clear canvas if we're going to create a new one
    if (newState == PreviewState.image)
      _points.clear();
    _previewState = newState;
    notifyListeners();
  }

  String _currentImagePath;
  String get currentImagePath => _currentImagePath;
  set currentImagePath(String path) {
    _currentImagePath = path;
    notifyListeners();
  }

  Color _selectedColor = Colors.black;
  Color get selectedColor => _selectedColor;
  set selectedColor(Color newColor) {
    _selectedColor = newColor;
    notifyListeners();
  }

  List<DocumentItemModel> _documentItems = [];
  List<DocumentItemModel> get documentItems => _documentItems;
  set documentItems(List<DocumentItemModel> newItems) {
    _documentItems = newItems;
    notifyListeners();
  }

  MainModel(IFileService filesService, IPhotoboothService phBoothService, IImageService imageService) {
    _filesService = filesService;
    _phBoothService = phBoothService;
    _imageService = imageService;
  }

  Future<bool> saveAsPhotoboothDocument() async {
    if (currentImagePath == null || currentImagePath.isEmpty) {
      return false;
    }
    if (currentImagePath == null || points.isEmpty) {
      return false;
    }
    if (currentImagePath == null || canvasSize.isEmpty) {
      return false;
    }
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

  void addDocumentItem(String name, String pathToImage) {
    if (name == null || name.isEmpty)
      return;
    if (pathToImage == null || pathToImage.isEmpty)
      return;
    documentItems.add(DocumentItemModel(
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
    notifyListeners();
    previewState = PreviewState.empty;
  }

  Future<void> getImage(SourceOfImage from) async {
    Uint8List image;
    switch (from) {
      case SourceOfImage.fromCamera:
        image = await _imageService.getImageFromCamera();
        break;
      case SourceOfImage.fromGallery:
        image = await _imageService.getImageFromGallery();
        break;
      default:
    }
    if (image == null)
      return;
    // place it in temp folder
    final tempDir = await _filesService.getTempDirectory();
    final path = _filesService.join(tempDir, '${DateTime.now()}.png');
    var result = await _filesService.saveInFile(path, image);
    if (result) {
      currentImagePath = path;
      previewState = PreviewState.image;
    }
    else {
      print('MainModel.getImage(): couldn\'t write file in temp folder');
    }
  }

  /// Saves current canvas widget as PNG file in the gallery
  Future<bool> saveToGallery(GlobalKey canvasKey) async {
    // if canvas is empty there is nothing to save
    if (canvasKey == null)
      return false;
    // if context is empty we cannpt find render object
    if (canvasKey.currentContext == null)
      return false;

    try {
      // finding canvas of the widget
      RenderRepaintBoundary boundary = canvasKey.currentContext.findRenderObject();
      // transform the canvas into image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      // convert the image into png
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      // transfering png as sequence of bytes
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // making temp file
      final tempDir = await _filesService.getTempDirectory();
      final path = _filesService.join(tempDir, 'canvas_${DateTime.now()}.png');
      // write bytes into the file
      bool result = await _filesService.saveInFile(path, pngBytes);
      if (result)
        // saving temp file into OS gallery
        return await _imageService.saveImageInGallery(path);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
  // Returns saved represantation of photobooth documents
  Future<List<DocumentItemModel>> getDocuments() async {
    try {
      documentItems.clear();
      var docDirectory = await _filesService.getDocumentDirectory();
      var dirs = _filesService.getDirectories(docDirectory);
      for (var dir in dirs) {
        var name = _filesService.basename(dir.path);
        var pathToImage = _filesService.join(dir.path, '$name.png');
        documentItems.add(DocumentItemModel(
          name: name, 
          pathToImage: pathToImage)
        );
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return documentItems;
  }

  Future<bool> placeDocumentOnCanvas(DocumentItemModel model) async {
    try {
      currentImagePath = model.pathToImage;
      previewState = PreviewState.image;
      var docFolder = await _filesService.getDocumentDirectory();
      var pathToJson = _filesService.join(docFolder, model.name, '${model.name}.json');
      var file = await _filesService.readFileAsString(pathToJson);
      var doc = PhotoboothDocument.fromJson(json.decode(file));
      var drawingArea = _phBoothService.toDrawingPoints(doc);
      points.clear();
      _points = drawingArea.points;
    } catch (e) {
      print(e);
      return false;
    }
    notifyListeners();
    return points.length > 0;
  }
}

class DocumentItemModel {
  String name;
  String pathToImage;
  DocumentItemModel({this.name, this.pathToImage});
}

enum PreviewState { empty, image }
enum ImageFormat { png, jpeg, photobooth }
enum SourceOfImage { fromCamera, fromGallery, fromDocuments }