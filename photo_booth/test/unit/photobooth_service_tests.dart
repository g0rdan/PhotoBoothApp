import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_booth/services/photobooth_service.dart';
import 'package:photo_booth/models/drawing_point.dart';
import 'package:photo_booth/models/photobooth_doc.dart';

import 'mock_models.dart';

void main() {
  // the service which is under testing
  var photoboothService = PhotoboothService(FileServiceMock());
  // test (mock) object of canvas
  var mockCanvas = DrawingArea.createMock();
  var mockDocument = PhotoboothDocument.createMock();

  group('toPhotoboothFormat() function) ', () {

    test('Should return correct photobooth document', () {
      var photoboothDoc = photoboothService.toPhotoboothFormat(mockCanvas);  
      expect(photoboothDoc == null, false);
    });

    test('Should return null because of incorrect argument', () {
      var photoboothDoc = photoboothService.toPhotoboothFormat(null);  
      expect(photoboothDoc == null, true);
    });

    test('Should return only one line', () {
      var photoboothDoc = photoboothService.toPhotoboothFormat(mockCanvas);  
      expect(photoboothDoc.lines.length == 1, true);
    });

    test('Should return line which has excact two points', () {
      var photoboothDoc = photoboothService.toPhotoboothFormat(mockCanvas);  
      expect(photoboothDoc.lines.first.points.length == 2, true);
    });

    test('Should return right size of canvas', () {
      var photoboothDoc = photoboothService.toPhotoboothFormat(mockCanvas);  
      expect(
        (photoboothDoc.widht == 10 && photoboothDoc.height == 10), 
        true
      );
    });
  });

  group('toDrawingPoints() function', () {

    test('Shouldn\'t return null if document is correct', () {
      var canvas = photoboothService.toDrawingPoints(mockDocument);
      expect(canvas == null, false);
    });

    test('Should return null if document is incorrect', () {
      var canvas = photoboothService.toDrawingPoints(null);  
      expect(canvas == null, true);
    });

    test('Shouldn\'t return two points in the row (it has to be 3 with separator)', () {
      var canvas = photoboothService.toDrawingPoints(mockDocument);
      expect(canvas.points.length == 2, false);
    });

    test('Should have Size(10, 10)', () {
      var canvas = photoboothService.toDrawingPoints(mockDocument);
      expect(canvas.size == Size(10, 10), true);
    });
  });

  group('saveCanvasAsFile() function', () {
    
    test('Should return false if path to image is an empty string', () {
      var pathToImage = '';
      photoboothService.saveCanvasAsFile(pathToImage, mockCanvas).then((onValue) {
        expect(onValue, false);
      });
    });

    test('Should return false if canvas is null', () {
      var pathToImage = '/path/to/image';
      photoboothService.saveCanvasAsFile(pathToImage, null).then((onValue) {
        expect(onValue, false);
      });
    });

    test('Should return true if all arguments are correct', () {
      var pathToImage = '/path/to/image';
      photoboothService.saveCanvasAsFile(pathToImage, mockCanvas).then((onValue) {
        expect(onValue, true);
      });
    });
  });
}