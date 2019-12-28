import 'dart:io';
import 'dart:ui';

class ColorConverter {
  static String toHEX(Color color) {
    int colorValue = color.value;
    String colorString = colorValue.toString();
    colorString = colorString.substring(2);
    return colorString;
  }

  static Color toColor(String color) {
    color = color.toUpperCase().replaceAll('#', '');
    if (color.length == 6) color = 'FF' + color;
    return Color(int.parse(color, radix: 16));
  }
}

class PaintExtensions {
  static getDeafultPaint(Color color) {
    return Paint()
      ..strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = 3.0;
  }
}

