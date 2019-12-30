import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_booth/services/files_service.dart';
import 'package:photo_booth/services/photobooth_service.dart';
import 'package:photo_booth/services/image_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';

import 'scope_models/main_model.dart';
import 'ui/alert_view.dart';
import 'ui/draw_canvas.dart';

void main() => runApp(PhotoboothApp());

class PhotoboothApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Photo Booth App'
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

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
  GlobalKey canvasKey = GlobalKey();
  FileService _fileService = FileService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ScopedModel(
      model: MainModel(
        _fileService,
        PhotoboothService(_fileService),
        ImageService()
      ),
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
                      color: Colors.blue[100]),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 10,
                        top: 20,
                        child: Row(
                          children: <Widget>[
                            Opacity(
                              opacity: model.previewState == PreviewState.image ? 1.0 : 0.5,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: FloatingActionButton(
                                  backgroundColor: model.selectedColor,
                                  onPressed: () {
                                    if (model.previewState == PreviewState.image)
                                      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 30, left: 8, top: 8, right: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: getColorList(model, context),
                                          ),
                                        );
                                      });
                                  },
                                  tooltip: 'Choise color',
                                  child: Icon(Icons.color_lens),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0.0),
                              child: PopupMenuButton<SourceOfImage>(
                                child: FloatingActionButton(
                                  tooltip: 'Take photo',
                                  child: Icon(Icons.image),
                                ),
                                onSelected: (SourceOfImage result) async {
                                  switch (result) {
                                    case SourceOfImage.fromCamera:
                                      model.getImage(SourceOfImage.fromCamera);
                                      break;
                                    case SourceOfImage.fromGallery:
                                      model.getImage(SourceOfImage.fromGallery);
                                      break;
                                    case SourceOfImage.fromDocuments:
                                      await model.getDocuments();
                                      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                                        return Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: model.documentItems.length,
                                              itemBuilder: (context, index) {
                                                final item = model.documentItems[index];
                                                return Column (
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(item.name),
                                                      leading: Image.file(File(item.pathToImage)),
                                                      onTap: () {
                                                        model.placeDocumentOnCanvas(item);
                                                      },
                                                    ),
                                                    Divider()
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                      break;
                                    default:
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<SourceOfImage>>[
                                  const PopupMenuItem<SourceOfImage>(
                                    value: SourceOfImage.fromCamera,
                                    child: Text('Open Camera'),
                                  ),
                                  const PopupMenuItem<SourceOfImage>(
                                    value: SourceOfImage.fromGallery,
                                    child: Text('Open Photos'),
                                  ),
                                  const PopupMenuItem<SourceOfImage>(
                                    value: SourceOfImage.fromDocuments,
                                    child: Text('Open Documents'),
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
                            Opacity(
                              opacity: model.previewState == PreviewState.image ? 1.0 : 0.5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.fiber_new),
                                    tooltip: 'Clear work area',
                                    onPressed: () {
                                      if (model.previewState == PreviewState.image)
                                        model.clear();
                                    }
                                  ),
                                  Text('New')
                                ],
                              ),
                            ),
                            Opacity(
                              opacity: model.previewState == PreviewState.image ? 1.0 : 0.5,
                              child: PopupMenuButton<ImageFormat>(
                                enabled: model.previewState == PreviewState.image,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.save),
                                      tooltip: 'Save',
                                      onPressed: () {},
                                    ),
                                    Text('Save')
                                  ],
                                ),
                                onSelected: (ImageFormat result) async {
                                  if (model.previewState == PreviewState.image) {
                                    String title = 'Congratulations';
                                    String okText = 'OK';
                                    switch (result) {
                                      case ImageFormat.png:
                                        bool result = await model.saveToGallery(canvasKey);
                                        if (result) {
                                          String desciption = 'The image has been saved in Gallery';
                                          if (Platform.isIOS) {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertView(title, desciption, okText);
                                              }
                                            );
                                          }
                                          else {
                                            showDialog(
                                              context: context, 
                                              child: AlertView(title, desciption, okText)
                                            );
                                          }
                                        }
                                        break;
                                      case ImageFormat.photobooth:
                                        bool result = await model.saveAsPhotoboothDocument();
                                        if (result) {
                                          String desciption = 'The image has been saved in Documets';
                                          if (Platform.isIOS) {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertView(title, desciption, okText);
                                              }
                                            );
                                          }
                                          else {
                                            showDialog(
                                              context: context, 
                                              child: AlertView(title, desciption, okText)
                                            );
                                          }
                                        }
                                        break;
                                      default:
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<ImageFormat>>[
                                  const PopupMenuItem<ImageFormat>(
                                    value: ImageFormat.png,
                                    child: Text('Save as PNG'),
                                  ),
                                  const PopupMenuItem<ImageFormat>(
                                    value: ImageFormat.photobooth,
                                    child: Text('Save as PhotoBooth Document'),
                                  ),
                                ],
                              ),
                            ),
                            Opacity(
                              opacity: model.points.isEmpty ? 0.5 : 1.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.undo),
                                    tooltip: 'Undo changes in work area',
                                    onPressed: () {
                                      if (model.points.isNotEmpty)
                                        model.undo();
                                    }
                                  ),
                                  Text('Undo')
                                ],
                              ),
                            )
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
                        color: Colors.grey[200]
                      ),
                      child: DrawCanvas(canvasKey),
                    ),
                  )
                )
              ],
            ) 
          )
        ),
      ),
    );
  }

  getColorList(MainModel model, BuildContext context) {
    List<Widget> listWidget = [];
    for (Color color in model.colors) {
      listWidget.add(colorCircle(model, color, context));
    }
    return listWidget;
  }

  Widget colorCircle(MainModel model, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        model.selectedColor = color;
        Navigator.pop(context);
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