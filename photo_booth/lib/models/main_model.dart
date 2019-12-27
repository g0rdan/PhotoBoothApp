import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart' as imagePicker;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
}

class DrawingPoint {
  Paint paint;
  Offset point;
  bool separator;
  DrawingPoint({this.point, this.paint, this.separator});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
enum CameraPreviewState { empty, image }
// enum ImageSource { fromFile, fromCamera }