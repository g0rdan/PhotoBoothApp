import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/main_model.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final lastCamera = cameras.last; //cameras.first;

  // runApp(MyApp());

  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        camera: lastCamera
      )
    ),
  );
}

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera;

  MyHomePage({Key key, this.title, this.camera}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

   @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
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
                                // onPressed: _incrementCounter,
                                tooltip: 'Choise color',
                                child: Icon(Icons.color_lens),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0.0),
                              child: PopupMenuButton<ImageSource>(
                                child: FloatingActionButton(
                                  tooltip: 'Take photo',
                                  child: Icon(Icons.image),
                                ),
                                onSelected: (ImageSource result) {
                                  switch (result) {
                                    case ImageSource.fromCamera:
                                      model.setPreviewState(CameraPreviewState.preview);
                                      break;
                                    default:
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<ImageSource>>[
                                  const PopupMenuItem<ImageSource>(
                                    value: ImageSource.fromCamera,
                                    child: Text('Open Camera'),
                                  ),
                                  const PopupMenuItem<ImageSource>(
                                    value: ImageSource.fromFile,
                                    child: Text('Open Photos'),
                                  ),
                                ],
                              )
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
                      child: Draw(_controller),
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
  CameraController controller;

  Draw(this.controller);

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
          child: _getPreviewWidget(model)

          //  CustomPaint(
          //   // key: _globalKey,
          //   size: Size.infinite,
          //   painter: DrawingPainter(
          //     pointsList: model.points,
          //   ),
          // ),
        )
    );
  }

  _getPreviewWidget(MainModel model) {
    switch (model.previewState) {
      case CameraPreviewState.empty:
        print('empty preview');
        return Center(
          child: Text('Empty screen')
        );
        break;
      case CameraPreviewState.preview:
        print('camera preview');
        return CameraView(widget.controller);
        break;
      case CameraPreviewState.image:
        print('draw screen');
        return Stack(
          children: <Widget>[
            DisplayPictureScreen(imagePath: model.currentImagePath),
            CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(
                pointsList: model.points,
              ),
            )
          ],
        );
        break;
      default:
    }
  }

  // getColorList() {
  //   List<Widget> listWidget = List();
  //   for (Color color in colors) {
  //     listWidget.add(colorCircle(color));
  //   }
  //   Widget colorPicker = GestureDetector(
  //     onTap: () {
  //       showDialog(
  //         context: context,
  //         child: AlertDialog(
  //           title: const Text('Pick a color!'),
  //           content: SingleChildScrollView(
  //             child: ColorPicker(
  //               pickerColor: pickerColor,
  //               onColorChanged: (color) {
  //                 pickerColor = color;
  //               },
  //               enableLabel: true,
  //               pickerAreaHeightPercent: 0.8,
  //             ),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: const Text('Save'),
  //               onPressed: () {
  //                 setState(() => selectedColor = pickerColor);
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //     child: ClipOval(
  //       child: Container(
  //         padding: const EdgeInsets.only(bottom: 16.0),
  //         height: 36,
  //         width: 36,
  //         decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //           colors: [Colors.red, Colors.green, Colors.blue],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         )),
  //       ),
  //     ),
  //   );
  //   listWidget.add(colorPicker);
  //   return listWidget;
  // }

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

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File(imagePath));
  }
}

class CameraView extends CameraPreview {
  CameraView(CameraController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    var baseWidget = super.build(context);
    return ScopedModelDescendant<MainModel>(
      builder: (context, _, model) => Stack(
        children: <Widget>[
          baseWidget,
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  // await _initializeControllerFuture;

                  // Construct the path where the image should be saved using the
                  // pattern package.
                  final path = join(
                    // Store the picture in the temp directory.
                    // Find the temp directory using the `path_provider` plugin.
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );

                  model.currentImagePath = path;

                  // Attempt to take a picture and log where it's been saved.
                  await controller.takePicture(model.currentImagePath);
                  model.setPreviewState(CameraPreviewState.image);

                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: ClipOval(
                child: Container(
                  color: Colors.red,
                  height: 60.0, // height of the button
                  width: 60.0, // width of the button
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
