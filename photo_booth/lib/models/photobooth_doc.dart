import 'package:json_annotation/json_annotation.dart';

part 'photobooth_doc.g.dart';

@JsonSerializable(explicitToJson: true)
class PhotoboothPencilDocument {
  double widht;
  double height;
  List<PhotoboothLine> lines = [];

  PhotoboothPencilDocument();

  factory PhotoboothPencilDocument.fromJson(Map<String, dynamic> json) => _$PhotoboothPencilDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoboothPencilDocumentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PhotoboothLine {
  int color;
  List<PhotoboothPoint> points = [];

  PhotoboothLine();

  factory PhotoboothLine.fromJson(Map<String, dynamic> json) => _$PhotoboothLineFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoboothLineToJson(this);
}

@JsonSerializable()
class PhotoboothPoint {
  double x;
  double y;

  PhotoboothPoint();

  factory PhotoboothPoint.fromJson(Map<String, dynamic> json) => _$PhotoboothPointFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoboothPointToJson(this);
}