// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photo_booth/main.dart';

void main() {

  testWidgets('Check if there is a text on empty blank', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PhotoboothApp());
    expect(find.text('Please choose a picture for drawing.'), findsOneWidget);
  });
  
  testWidgets('Check if choose pics button works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PhotoboothApp());
    await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.image));
    await tester.pump();
    expect(find.text('Open Camera'), findsOneWidget);
    expect(find.text('Open Photos'), findsOneWidget);
    expect(find.text('Open Documents'), findsOneWidget);
  });
}
