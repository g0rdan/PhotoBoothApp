import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart' as imagePicker;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {

  GlobalKey canvasKey;

  Color selectedColor = Colors.black;
  bool showColorsWidget = false;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  CameraPreviewState previewState = CameraPreviewState.empty;

  String _currentImagePath;
  String get currentImagePath => _currentImagePath;
  set currentImagePath(String path) {
    print(path);
    _currentImagePath = path;
  }

  List<DrawingPoint> _points = [];
  List<DrawingPoint> get points => _points;

  void addPoint(DrawingPoint point) {
    _points.add(point);
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
    previewState = CameraPreviewState.empty;
    notifyListeners();
  }

  void setPreviewState(CameraPreviewState newPreviewState) {
    previewState = newPreviewState;
    print('state: $previewState');
    notifyListeners();
  }

  Future<void> getImage(imagePicker.ImageSource from) async {
    var image = await imagePicker.ImagePicker.pickImage(source: from);

    final bytes = image.readAsBytesSync();
    final bLength = bytes.length;
    print('bytes: $bLength');
    final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
    print('path: $path');
    var tempfile = File(path);
    tempfile.writeAsBytesSync(bytes);

    currentImagePath = path;
    setPreviewState(CameraPreviewState.image);
    notifyListeners();
  }

  Future<bool> saveImage(ImageFormat imageFormat) async {
    if (currentImagePath.isEmpty) {
      print('temp image path is empty');
      return false;
    }
    
    if (canvasKey == null){
      print('canvas key is null');
      return false;
    }

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
      final path = join((await getTemporaryDirectory()).path, 'canvas_${DateTime.now()}.png');
      var tempfile = File(path);
      // write bytes into the file
      tempfile.writeAsBytesSync(pngBytes);
      // saving temp file into OS gallery
      return await GallerySaver.saveImage(tempfile.path);
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class DrawingPoint {
  Paint paint;
  Offset point;
  bool separator;
  DrawingPoint({this.point, this.paint, this.separator});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
enum CameraPreviewState { empty, image }
enum ImageFormat { png, jpeg, photobooth }
// enum ImageSource { fromFile, fromCamera }