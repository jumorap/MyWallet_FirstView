import 'package:emulateios/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,//We dont wanna that see the appBar
        title: Text("Category",
          style: TextStyle(
            color: Colors.grey,
          )
        ),
        centerTitle: false,
        actions: <Widget>[//Next button have the function of close the activity
          IconButton(
            icon: Icon(Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector();
  Widget _currentValue();
  Widget _numpad();
  Widget _submit();
}


