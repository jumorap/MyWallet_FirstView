import 'package:emulateios/month_widget.dart';
import 'package:emulateios/pages/add_page.dart';
import 'package:emulateios/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: { //Declarate the routes-pages-layouts to surf about the app
        '/': (BuildContext context) => MyHomePage(),
        '/add': (BuildContext context) => AddPage(),
      },
    );
  }
}

