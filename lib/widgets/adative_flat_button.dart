import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFLatButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveFLatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              'Choose a date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: handler,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              'Choose a date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: handler,
          );
  }
}
