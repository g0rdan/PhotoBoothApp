import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:photo_booth/models/photobooth_doc.dart';
import 'package:photo_booth/services/files_service.dart';
import 'package:photo_booth/models/drawing_point.dart';

import '../extensions/ui_extensions.dart';

class PhotoboothFormatService {

  FileService _filesService;

  PhotoboothFormatService(FileService filesService) {
    _filesService = filesService;
  }

  Future<bool> saveCanvasAsFile(String pathToImage, DrawingArea canvas) async {
    try {
      var dateTime = DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
      String name = formatter.format(dateTime);
      // create fodler for image and json
      var docFodler = await _filesService.createDocumentFolder(name);
      // write original image to the fodler
      var imageFilename = '$name.png';
      var imagePath = join(docFodler.path, imageFilename);
      var tempBytes = await File(pathToImage).readAsBytes();
      await File(imagePath).writeAsBytes(tempBytes);
      // write canvas data to the fodler
      var canavsFilename = '$name.json';
      var canvasDoc = toPhotoboothFormat(canvas);
      var canvasJson = json.encode(canvasDoc);
      var canvasPath = join(docFodler.path, canavsFilename);
      await File(canvasPath).writeAsString(canvasJson);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  PhotoboothPencilDocument toPhotoboothFormat(DrawingArea canvas) {
    if (canvas == null) {
      print('PhotoboothFormatService.toPhotoboothFormat(): canvas is null');
      return null;
    }
    if (canvas.points.isEmpty) {
      print('PhotoboothFormatService.toPhotoboothFormat(): there is no points');
      return null;
    }
    if (canvas.size.isEmpty) {
      print('PhotoboothFormatService.toPhotoboothFormat(): there is no canvas size');
      return null;
    }

    var document = PhotoboothPencilDocument();
    document.widht = canvas.size.width;
    document.height = canvas.size.height;
    int index = 0;
    while (index < canvas.points.length) {
      var slice = _getSlice(index, canvas.points);
      var color = slice[0].paint.color;
      var line = PhotoboothLine();
      line.color = color.value;
      for (var point in slice) {
        var photoboothPoint = PhotoboothPoint();
        photoboothPoint.x = point.point.dx;
        photoboothPoint.y = point.point.dy;
        line.points.add(photoboothPoint);
      }
      document.lines.add(line);
      index += slice.length + 1;
    }
    return document;
  }

  DrawingArea toDrawingPoints(PhotoboothPencilDocument document) {
    if (document == null) {
      print('PhotoboothFormatService.toDrawingPoints(): document is null');
      return null;
    }

    if (document.widht == 0 || document.height == 0) {
      print('PhotoboothFormatService.toDrawingPoints(): document\'s size si incorect');
      return null;
    }

    if (document.lines.isEmpty) {
      print('PhotoboothFormatService.toDrawingPoints(): there is no drawing points');
      return null;
    }

    var canvas = DrawingArea();
    canvas.size = Size(document.widht, document.height);
    canvas.points = new List<DrawingPoint>();
    for (var line in document.lines) {
      for (var point in line.points) {
        var drPont = DrawingPoint();
        var paint = PaintHelper.getDeafultPaint(Color(line.color));
        drPont.paint = paint;
        drPont.point = Offset(point.x, point.y);
        canvas.points.add(drPont);
      }
      // separater
      canvas.points.add(null);
    }
    return canvas;
  }

  List<DrawingPoint> _getSlice(int index, List<DrawingPoint> points) {
    var slice = List<DrawingPoint>();
    for (int i = index; i < points.length; i++) {
      if (points[i] != null)
        slice.add(points[i]);
      else
        break;
    }
    return slice;
  }
}