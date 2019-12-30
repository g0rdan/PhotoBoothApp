import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_booth/extensions/ui_extensions.dart';

class DrawingPoint {
  Paint paint;
  Offset point;
  DrawingPoint({this.point, this.paint});

  factory DrawingPoint.createMock(double x, double y) {
    return DrawingPoint(
      point: Offset(x, y),
      paint: PaintHelper.getDeafultPaint(Colors.black)
    );
  }
}

class DrawingArea {
  List<DrawingPoint> points;
  Size size;
  DrawingArea({this.points, this.size});

  factory DrawingArea.createMock(){
    return DrawingArea(
      points: [
        DrawingPoint.createMock(1, 1),
        DrawingPoint.createMock(2, 2)
      ],
      size: Size(10, 10)
    );
  }
}