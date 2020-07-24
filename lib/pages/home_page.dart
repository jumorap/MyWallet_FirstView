import 'package:emulateios/month_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../login_state.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  PageController _controller;
  int currentPage = DateTime.now().month - 1;
  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );

    setupNotificationPlugin();
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
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          //Next two lines build a notch in the blue button in center of dock
            notchMargin: 8.0,
            shape: CircularNotchedRectangle(),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _bottomAction(FontAwesomeIcons.chartLine, () {
                    setState(() {
                      currentType = GraphType.LINES;
                    });
                  }),
                  _bottomAction(FontAwesomeIcons.chartPie, () {
                    setState(() {
                      currentType = GraphType.PIE;
                    });
                  }),
                  //The dock size is defined by
                  SizedBox(width: 25.0, height: 50.0),
                  _bottomAction(FontAwesomeIcons.wallet, () {}),
                  _bottomAction(FontAwesomeIcons.signOutAlt, () {
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
                // We confirm if there is data to teach to our users, because if there is not,
                // we gonna teach a windows with an image that represent an empty
                if (data.connectionState == ConnectionState.active) {
                  if (data.data.documents.length > 0) {
                    return MonthWidget(
                      documents: data.data.documents,
                      graphType: currentType,
                      month: currentPage,
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/empty_cart.png'),
                          SizedBox(height: 80,),
                          Text(
                            "¡Añade tus gastos para empezar!",
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Expanded(
                  child: Center(//We present a bar load. Circular
                    child: CircularProgressIndicator(),
                  ),
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

  // With next lines we can send notifications to our user in specific time.
  // In this case was used the pluggin 'flutter_local_notifications 1.4.4+2'
  // visible in pubspec.yaml, from pub.dev. But continue in experimental process

  Future<void> setupNotificationPlugin() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification
    ).then((init) => setupNotification());
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Recuerda actualizar tus gastos hoy"),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  void setupNotification() async {
    var time = Time(20, 25, 0);
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'daily-notifications',
        'Daily Notifications',
        'Daily Notifications');
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Mis Gastos',
        'Recuerda actualizar tus gastos hoy',
        time,
        platformChannelSpecifics);
  }
}
