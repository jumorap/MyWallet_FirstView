import 'package:emulateios/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController _controller;
  int currentPage = 9;
  Stream<QuerySnapshot> _query;

  @override
  void initState() {
    super.initState();

    _query = Firestore.instance
        .collection('expenses')
        .where("month", isEqualTo: currentPage + 1)
        .snapshots();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }

  Widget _bottomAction(IconData icon){
    return InkWell(
      child: Icon(icon),
      onTap: (){},
    );
  }

  //Here is the dock found down
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        //Next two lines build a notch in the blue button in center of dock
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _bottomAction(FontAwesomeIcons.history),
                _bottomAction(FontAwesomeIcons.chartPie),
                //The dock size is defined by
                SizedBox(width: 25.0, height: 45.0),
                _bottomAction(FontAwesomeIcons.wallet),
                _bottomAction(Icons.settings),
              ]
          )
      ),
      //This is button blue that is in center of dock
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        //Next lines build one action to do that open a new page-layout in app. Is like a setOnClickListener in Java
        onPressed: (){
          Navigator.of(context).pushNamed('/add');
        },
      ),

      //Here we begin to build the body of app
      body: _body(),
    );
  }

  Widget _body(){
    //The next line works like safer of top notch
    return SafeArea(
      child: Column(
        //Define the "objects-widgets that appear in body"
          children: <Widget>[
            _selector(),
            StreamBuilder<QuerySnapshot>(
              stream: _query,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
                if (data.hasData) {
                  return MonthWidget(
                    documents: data.data.documents,
                  );
                }
                return Center(//We present a bar load. Circular
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ]
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;

    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else {
      _alignment = Alignment.center;
    }

    return Align(
        alignment: _alignment,
        child: Text(name,
          style: position == currentPage ? selected : unselected,
        )
    );
  }
  Widget _selector(){//Create an horizonal "menu-deslizable*"
    return SizedBox.fromSize(
        size: Size.fromHeight(70.0),
        child: PageView(
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
                _query = Firestore.instance
                    .collection('expenses')
                    .where("month", isEqualTo: currentPage + 1)
                    .snapshots();
              });
            },
            controller: _controller,
            children: <Widget>[
              _pageItem("Enero", 0),
              _pageItem("Febrero", 1),
              _pageItem("Marzo", 2),
              _pageItem("Abril", 3),
              _pageItem("Mayo", 4),
              _pageItem("Junio", 5),
              _pageItem("Julio", 6),
              _pageItem("Agosto", 7),
              _pageItem("Septiembre", 8),
              _pageItem("Octubre", 9),
              _pageItem("Noviembre", 10),
              _pageItem("Diciembre", 11),
            ]
        )
    );
  }


}
