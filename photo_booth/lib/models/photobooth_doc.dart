import 'package:json_annotation/json_annotation.dart';

part 'photobooth_doc.g.dart';

@JsonSerializable(explicitToJson: true)
class PhotoboothDocument {
  double widht;
  double height;
  List<PhotoboothLine> lines = [];

  PhotoboothDocument();

  factory PhotoboothDocument.fromJson(Map<String, dynamic> json) => _$PhotoboothDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoboothDocumentToJson(this);

  factory PhotoboothDocument.createMock() {
    var testDocument = PhotoboothDocument();
    testDocument.widht = 10;
    testDocument.height = 10;
    testDocument.lines = List<PhotoboothLine>();
    var line = PhotoboothLine();
    line.color = 234234;
    line.points = List<PhotoboothPoint>();
    var firstPoint = PhotoboothPoint();
    firstPoint.x = 1;
    firstPoint.y = 1;
    var secondPoint = PhotoboothPoint();
    secondPoint.x = 2;
    secondPoint.y = 2;
    line.points.add(firstPoint);
    line.points.add(secondPoint);
    testDocument.lines.add(line);
    return testDocument;
  }
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