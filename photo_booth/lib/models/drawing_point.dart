import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingPoint {
  Paint paint;
  Offset point;
  DrawingPoint({this.point, this.paint});
}

class DrawingArea {
  List<DrawingPoint> points;
  Size size;
  DrawingArea({this.points, this.size});
}