import 'package:emulateios/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../login_state.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController _controller;
  int currentPage = DateTime.now().month - 1;
  Stream<QuerySnapshot> _query;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }

  Widget _bottomAction(IconData icon, Function callback){
    return InkWell(
      // Next line can build a padding on the down buttons, giving place to be selected
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: callback,
    );
  }

  //Here is the dock found down
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
        builder: (BuildContext context, LoginState state, Widget child) {
          var user = Provider.of<LoginState>(context).currentUser();
          // Like in "add_page.dart", we call our database Firebase, and after call the collection of our instance users, after,
          // we generate from the ID [user.uid] that came from the sync of Google Account another collection
          // where we gonna save the data added by our users. So, we can separate individually the data for user
          // and after teach the information to our users
          _query = Firestore.instance
              .collection('users')
              .document(user.uid)
              .collection('expenses')
              .where("month", isEqualTo: currentPage + 1)
              .snapshots();
      return Scaffold(
        bottomNavigationBar: BottomAppBar(
          //Next two lines build a notch in the blue button in center of dock
            notchMargin: 8.0,
            shape: CircularNotchedRectangle(),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _bottomAction(FontAwesomeIcons.history, () {}),
                  _bottomAction(FontAwesomeIcons.chartPie, () {}),
                  //The dock size is defined by
                  SizedBox(width: 25.0, height: 50.0),
                  _bottomAction(FontAwesomeIcons.wallet, () {}),
                  _bottomAction(Icons.settings, () {
                    Provider.of<LoginState>(context).logout();
                  }),
                ]
            )
        ),
        //This is blue button that is in center of dock
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          //Next lines build one action to open a new page-layout in app. Is like a setOnClickListener in Java
          onPressed: () {
            Navigator.of(context).pushNamed('/add');
          },
        ),
        //Here we begin to build the body of app
        body: _body(),
      );
    });
  }

  Widget _body(){
    //The next line works like safer of top notch
    return SafeArea(
      child: Column(
        //Define the "objects-widgets" that appear in body
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
              }),
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
      fontSize: 13.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.5),
    );
    _alignment = Alignment.center;

    return Align(
        alignment: _alignment,
        child: Text(name,
          style: position == currentPage ? selected : unselected,
        )
    );
  }
  Widget _selector(){//Create an horizontal "menu-deslizable*"
    return SizedBox.fromSize(
        size: Size.fromHeight(70.0),
        child: PageView(
            onPageChanged: (newPage) {
              setState(() {
                var user = Provider.of<LoginState>(context).currentUser();
                currentPage = newPage;
                _query = Firestore.instance
                    .collection('users')
                    .document(user.uid)
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
