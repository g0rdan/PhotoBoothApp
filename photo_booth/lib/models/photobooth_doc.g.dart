// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photobooth_doc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoboothPencilDocument _$PhotoboothPencilDocumentFromJson(
    Map<String, dynamic> json) {
  return PhotoboothPencilDocument()
    ..widht = (json['widht'] as num)?.toDouble()
    ..height = (json['height'] as num)?.toDouble()
    ..lines = (json['lines'] as List)
        ?.map((e) => e == null
            ? null
            : PhotoboothLine.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PhotoboothPencilDocumentToJson(
        PhotoboothPencilDocument instance) =>
    <String, dynamic>{
      'widht': instance.widht,
      'height': instance.height,
      'lines': instance.lines?.map((e) => e?.toJson())?.toList(),
    };

PhotoboothLine _$PhotoboothLineFromJson(Map<String, dynamic> json) {
  return PhotoboothLine()
    ..color = json['color'] as String
    ..points = (json['points'] as List)
        ?.map((e) => e == null
            ? null
            : PhotoboothPoint.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PhotoboothLineToJson(PhotoboothLine instance) =>
    <String, dynamic>{
      'color': instance.color,
      'points': instance.points?.map((e) => e?.toJson())?.toList(),
    };

PhotoboothPoint _$PhotoboothPointFromJson(Map<String, dynamic> json) {
  return PhotoboothPoint()
    ..x = (json['x'] as num)?.toDouble()
    ..y = (json['y'] as num)?.toDouble();
}

Map<String, dynamic> _$PhotoboothPointToJson(PhotoboothPoint instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
