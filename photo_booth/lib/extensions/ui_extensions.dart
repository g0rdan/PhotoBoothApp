import 'dart:io';
import 'dart:ui';

class PaintHelper {
  static getDeafultPaint(Color color) {
    return Paint()
      ..strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = 3.0;
  }
}