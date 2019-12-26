import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
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
                              setState(() {
                                // if (selectedMode == SelectedMode.StrokeWidth)
                                //   showBottomList = !showBottomList;
                                // selectedMode = SelectedMode.StrokeWidth;
                              });
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
                              setState(() {
                                // if (selectedMode == SelectedMode.StrokeWidth)
                                //   showBottomList = !showBottomList;
                                // selectedMode = SelectedMode.StrokeWidth;
                              });
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
                  height: 100,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.blueAccent
                  ),
                ),
              )
            )
          ],
        ) 
      )
       
      
       
      
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Container(
      //       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(50.0),
      //           color: Colors.greenAccent),
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: <Widget>[
      //             Row(
      //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: <Widget>[

      //                 Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: <Widget>[
      //                     IconButton(
      //                     icon: Icon(Icons.fiber_new),
      //                     tooltip: 'Clear work area',
      //                     onPressed: () {
      //                       setState(() {
      //                         // if (selectedMode == SelectedMode.StrokeWidth)
      //                         //   showBottomList = !showBottomList;
      //                         // selectedMode = SelectedMode.StrokeWidth;
      //                       });
      //                     }),
      //                     Text('New')
      //                   ],
      //                 ),

      //                 Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: <Widget>[
      //                     IconButton(
      //                     icon: Icon(Icons.save),
      //                     tooltip: 'Save work area into file',
      //                     onPressed: () {
      //                       setState(() {
      //                         // if (selectedMode == SelectedMode.StrokeWidth)
      //                         //   showBottomList = !showBottomList;
      //                         // selectedMode = SelectedMode.StrokeWidth;
      //                       });
      //                     }),
      //                     Text('Save')
      //                   ],
      //                 ),

      //                 Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: <Widget>[
      //                     IconButton(
      //                     icon: Icon(Icons.undo),
      //                     tooltip: 'Undo changes in work area',
      //                     onPressed: () {
      //                       setState(() {
      //                         // if (selectedMode == SelectedMode.StrokeWidth)
      //                         //   showBottomList = !showBottomList;
      //                         // selectedMode = SelectedMode.StrokeWidth;
      //                       });
      //                     }),
      //                     Text('Undo')
      //                   ],
      //                 ),

      //               ],
      //             )
      //             // Visibility(
      //             //   child: (selectedMode == SelectedMode.Color)
      //             //       ? Row(
      //             //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             //           children: getColorList(),
      //             //         )
      //             //       : Slider(
      //             //           value: (selectedMode == SelectedMode.StrokeWidth)
      //             //               ? strokeWidth
      //             //               : opacity,
      //             //           max: (selectedMode == SelectedMode.StrokeWidth)
      //             //               ? 50.0
      //             //               : 1.0,
      //             //           min: 0.0,
      //             //           onChanged: (val) {
      //             //             setState(() {
      //             //               if (selectedMode == SelectedMode.StrokeWidth)
      //             //                 strokeWidth = val;
      //             //               else
      //             //                 opacity = val;
      //             //             });
      //             //           }),
      //             //   visible: showBottomList,
      //             // ),
      //           ],
      //         ),
      //       )),
      // ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
