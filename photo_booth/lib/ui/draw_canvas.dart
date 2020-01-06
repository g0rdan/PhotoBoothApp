import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_booth/models/drawing_point.dart';
import 'package:photo_booth/scope_models/main_model.dart';
import 'package:photo_booth/extensions/ui_extensions.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

/// Widget that helps drawing on the images
class DrawCanvas extends StatefulWidget {
  GlobalKey canvasKey;
  MainModel model;

  DrawCanvas(this.canvasKey, this.model);

  @override
  _DrawCanvasState createState() => _DrawCanvasState();
}

class _DrawCanvasState extends State<DrawCanvas> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, _, model) => 
        RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: <Type, GestureRecognizerFactory>{
            ImmediateMultiDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<ImmediateMultiDragGestureRecognizer>(
              () => ImmediateMultiDragGestureRecognizer(),
              (ImmediateMultiDragGestureRecognizer instance) {
                instance
                  ..acceptGesture(2)
                  ..onStart = _handleOnStart;
                }
            ),
          }, child: _getPreviewWidget(model),
        )
    );
  }

  Drag _handleOnStart(Offset position) {
    final String id = Uuid().v4();
    widget.model.touchGuids.add(id);
    return _DragHandler(
      (updateDetaild) {
        RenderBox renderBox = context.findRenderObject();
        final currPoint = renderBox.globalToLocal(updateDetaild.globalPosition);
        if (currPoint.dx > 0 && currPoint.dy > 0 && currPoint.dx < renderBox.size.width && currPoint.dy < renderBox.size.height) {
          final point = DrawingPoint(
              point: currPoint,
              paint: PaintHelper.getDeafultPaint(widget.model.selectedColor));
          widget.model.addPoint(point);
        }
      },
      (endDetaild) {
        setState(() {
          widget.model.addPoint(null);
        });
      }
    );
  }

  _getPreviewWidget(MainModel model) {
    switch (model.previewState) {
      case PreviewState.empty:
        return Center(
          child: Text('Please choose a picture for drawing.')
        );
        break;
      case PreviewState.image:
        return RepaintBoundary(
          key: widget.canvasKey,
          child: CustomPaint(
            child: DisplayPictureScreen(imagePath: model.currentImagePath),
            foregroundPainter: DrawingPainter(
              pointsList: model.points,
            ),
          ),
        );
        break;
      default:
    }
  }
}

class _DragHandler extends Drag {
  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;
  
  _DragHandler(this.onUpdate, this.onEnd);

  @override
  void update(DragUpdateDetails details) {
   onUpdate(details);
  }

  @override
  void end(DragEndDetails details) {
    onEnd(details);
  }

  @override
  void cancel(){}
}

class DrawingPainter extends CustomPainter {
  List<DrawingPoint> pointsList;
  List<Offset> offsetPoints = [];

  DrawingPainter({this.pointsList});
  
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        print('draw line');
        canvas.drawLine(pointsList[i].point, pointsList[i + 1].point,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].point);
        offsetPoints.add(Offset(
            pointsList[i].point.dx + 0.1, pointsList[i].point.dy + 0.1));
        print('draw points');
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File(imagePath));
  }
}