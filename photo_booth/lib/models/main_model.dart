import 'dart:ui';

import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {

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
    if (_points == null || _points.length <= 1)
      return;
    do {
      _points.removeLast();
    } while (_points.last != null);
    notifyListeners();
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
}

class DrawingPoint {
  Paint paint;
  Offset point;
  bool separator;
  DrawingPoint({this.point, this.paint, this.separator});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
enum CameraPreviewState { empty, preview, image }
enum ImageSource { fromFile, fromCamera }