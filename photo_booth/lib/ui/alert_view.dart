import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertView extends StatelessWidget {

  final String title;
  final String desciption;
  final String okText;

  AlertView(this.title, this.desciption, this.okText);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {  
      return CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(desciption),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(okText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]
      );
    }
    else {
      return AlertDialog(
        title: new Text(title),
        content: new Text(desciption),
        actions: <Widget>[
          FlatButton(
            child: Text(okText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }
}