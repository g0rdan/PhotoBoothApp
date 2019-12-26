import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/main_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ScopedModel(
      model: MainModel(),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (context, _, model) => Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.greenAccent),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 10,
                        top: 20,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: FloatingActionButton(
                                onPressed: _incrementCounter,
                                tooltip: 'Choise color',
                                child: Icon(Icons.color_lens),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0.0),
                              child: FloatingActionButton(
                                onPressed: _incrementCounter,
                                tooltip: 'Take photo',
                                child: Icon(Icons.photo_camera),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                icon: Icon(Icons.fiber_new),
                                tooltip: 'Clear work area',
                                onPressed: () {
                                  model.clear();
  
                                    // if (selectedMode == SelectedMode.StrokeWidth)
                                    //   showBottomList = !showBottomList;
                                    // selectedMode = SelectedMode.StrokeWidth;
                                  
                                }),
                                Text('New')
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.save),
                                  tooltip: 'Save work area into file',
                                  onPressed: () {
                                    setState(() {
                                      // if (selectedMode == SelectedMode.StrokeWidth)
                                      //   showBottomList = !showBottomList;
                                      // selectedMode = SelectedMode.StrokeWidth;
                                    });
                                }),
                                Text('Save')
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                icon: Icon(Icons.undo),
                                tooltip: 'Undo changes in work area',
                                onPressed: () {
                                  model.undo();
                                  // setState(() {
                                    
                                  //   // if (selectedMode == SelectedMode.StrokeWidth)
                                  //   //   showBottomList = !showBottomList;
                                  //   // selectedMode = SelectedMode.StrokeWidth;
                                  // });
                                }),
                                Text('Undo')
                              ],
                            ),
                          ],
                        )
                    ),
                  ],
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.blueAccent
                      ),
                      child: Draw(),
                    ),
                  )
                )
              ],
            ) 
          )
        ) 
      )
    );
  }
}

class Draw extends StatefulWidget {
  
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {

  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, _, model) => 
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              final currPoint = renderBox.globalToLocal(details.globalPosition);
              if (currPoint.dx > 0 && currPoint.dy > 0 && currPoint.dx < renderBox.size.width && currPoint.dy < renderBox.size.height) {
              final point = DrawingPoint(
                  point: currPoint,
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth);
                model.addPoint(point);
              }
            });
          },
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              final currPoint = renderBox.globalToLocal(details.globalPosition);
              if (currPoint.dx > 0 && currPoint.dy > 0 && currPoint.dx < renderBox.size.width && currPoint.dy < renderBox.size.height) {
                final point = DrawingPoint(
                  point: currPoint,
                  separator: false,
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth);
                model.addPoint(point);
              }
            });
          },
          onPanEnd: (details) {
            setState(() {
              print("on pan end");
              model.points.add(null);
            });
          },
          child: new Stack(
            children: <Widget>[
              new Positioned(
                left: 50.0,
                top: 50.0,
                child: new Icon(Icons.monetization_on, size: 36.0, color: const Color.fromRGBO(218, 165, 32, 1.0))
              ),
              CustomPaint(
                  // key: _globalKey,
                  size: Size.infinite,
                  painter: DrawingPainter(
                    pointsList: model.points,
                  ),
                ),
            ],
          ),
        )
    );
  }

  getColorList() {
    List<Widget> listWidget = List();
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                enableLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  setState(() => selectedColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoint> pointsList;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].point, pointsList[i + 1].point,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].point);
        offsetPoints.add(Offset(
            pointsList[i].point.dx + 0.1, pointsList[i].point.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
