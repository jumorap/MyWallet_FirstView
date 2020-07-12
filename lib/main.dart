import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController _controller;
  int currentPage = 9;

  @override
  void initState() {
    super.initState();
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
        onPressed: (){},
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
          _expenses(),
          _graph(),
          _list(),
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

  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text("\$777,41", //Next lines give style to Text
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0
          )
        ),
        Text("Total expenses", //Next lines give style to Text
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey
          )
        )
      ]
    );
  }

  Widget _graph() {
    return Container(
      height: 250.5,
      //child: GraphWidget(),
    ); // Container
  }

  Widget _item(IconData icon, String name, int percent, double value){
    return ListTile(
      leading: Icon(icon, size: 32.0),
      title: Text(name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      subtitle: Text("$percent% of expenses",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
      trailing: Container(
        //Realice a container-decoration to write the value
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5.0),
        ),
          child: Padding(//This is a PADDING, is so util to give a nice apparence
            padding: const EdgeInsets.all(8.0),
            child: Text("\$$value",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
      ),
    );
  }
  Widget _list() {
    //IMPORTANT!! Whith this line, we can do this widget SCROLLING
    return Expanded(
      child: ListView(
        children: <Widget>[
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          _item(Icons.local_drink, "Alcohol", 5, 15.0),
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
          _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
        ],
      ),
    );
  }
}
