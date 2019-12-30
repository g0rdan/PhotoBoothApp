import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_booth/scope_models/main_model.dart';
import 'package:photo_booth/models/drawing_point.dart';

import 'mock_models.dart';

void main() {
  // the mock services
  final photoboothServiceMock = PhotoboothServiceMock();
  final fileServiceMock = FileServiceMock();
  final imageServiceMock = ImageServiceMock();

  group('Properties tests', () {

    test('Check if there are six colors', () {
      var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
      expect(mainModel.colors.length == 6, true);
    });

    test('Should be two points in the points property after adding them through the method', () {
      var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
      var firstPoint = DrawingPoint.createMock(1, 2);
      var secondPoint = DrawingPoint.createMock(2, 1);
      mainModel.addPoint(firstPoint);
      mainModel.addPoint(secondPoint);
      expect(mainModel.points.length == 2, true);
    });

    test('Document preview list should\'n be empty after adding the document preview', () {
      var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
      mainModel.addDocumentItem('name', 'pathToImage');
      expect(mainModel.documentItems.length == 1, true);
    });

    test('Document preview list should be empty if one of arguments was null', () {
      var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
      mainModel.addDocumentItem(null, 'pathToImage');
      expect(mainModel.documentItems.length == 0, true);
    });

    /// It has to be done because when we want to put new image on canvas
    /// we want to clean all previous drawing on screen
    test('Points should be empty if we set PreviewState on \'image\'', () {
      var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
      var firstPoint = DrawingPoint.createMock(1, 2);
      var secondPoint = DrawingPoint.createMock(2, 1);
      mainModel.addPoint(firstPoint);
      mainModel.addPoint(secondPoint);
      expect(mainModel.points.length == 2, true);
      mainModel.previewState = PreviewState.image;
      expect(mainModel.points.length == 0, true);
    });

    group('saveAsPhotoboothDocument() tests', () {

      test('Should return false if we won\'t put imagePath or points or canvasSize', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.saveAsPhotoboothDocument().then((onValue){
          expect(onValue, false);
        });
      });

      test('Should return true if we put imagePath, points and canvasSize', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.currentImagePath = 'path/to/image';
        mainModel.addPoint(DrawingPoint.createMock(1, 2));
        mainModel.canvasSize = Size(10, 10);
        mainModel.saveAsPhotoboothDocument().then((onValue){
          expect(onValue, true);
        });
      });
    });

    group('Working with points tests', () {

      test('Should return true after adding some points', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.addPoint(DrawingPoint.createMock(1, 2));
        expect(mainModel.points.length > 0, true);
      });

      test('Should undo last line', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        // making first drawing line
        var firstLine = [
          DrawingPoint.createMock(0, 0),
          DrawingPoint.createMock(1, 1),
          DrawingPoint.createMock(2, 2),
        ];
        // making second drawing line
        var secondLine = [
          DrawingPoint.createMock(3, 3),
          DrawingPoint.createMock(4, 4),
          DrawingPoint.createMock(5, 5),
        ];
        // adding first line on canvas
        for (var point in firstLine) {
          mainModel.addPoint(point);
        }
        // making separation
        mainModel.addPoint(null);
        // adding second line on canvas
        for (var point in secondLine) {
          mainModel.addPoint(point);
        }
        // checking correct length of array
        expect(mainModel.points.length == 7, true);
        // undo last operation
        mainModel.undo();
        // checking correct length after undo
        expect(mainModel.points.length == 4, true);
      });

      test('Should clear points', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.addPoint(DrawingPoint.createMock(0, 1));
        mainModel.addPoint(DrawingPoint.createMock(0, 2));
        mainModel.addPoint(DrawingPoint.createMock(0, 3));
        expect(mainModel.points.length == 3, true);
        mainModel.clear();
        expect(mainModel.points.length == 0, true);
      });
    });

    group('getImage() function', () {

      test('Should get image from camera', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.getImage(SourceOfImage.fromCamera).then(((onValue){
          expect(mainModel.currentImagePath.isNotEmpty, true);
        }));
      });

      test('Should not get any image if we put fromDocuments argument', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.getImage(SourceOfImage.fromDocuments).then(((onValue){
          expect((mainModel.currentImagePath == null || mainModel.currentImagePath.isEmpty), true);
        }));
      });

      
    });

    group('saveToGallery() function', () {

      test('Should return false in GlobalKey is null', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.saveToGallery(null).then((onValue) {
          expect(onValue, false);
        });
      });

      test('Should return false in BuildingContext is null', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.saveToGallery(GlobalKey()).then((onValue) {
          expect(onValue, false);
        });
      });
    });

    group('getDocuments() function', () {

      test('Should return list of photobooth documents', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        mainModel.getDocuments().then((onValue) {
          expect(onValue.length > 0, true);
        });
      });
    });

    group('placeDocumentOnCanvas() function', () {

      test('Should return true if we give correct documentItemModel', () {
        var mainModel = MainModel(fileServiceMock, photoboothServiceMock, imageServiceMock);
        var model = DocumentItemModel();
        model.name = 'modelName';
        model.pathToImage = 'path/to/image';
        mainModel.placeDocumentOnCanvas(model).then((onValue) {
          expect(onValue, true);
        });
      });
    });
  });
}