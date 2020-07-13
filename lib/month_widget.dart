import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'greph_widget.dart';

class MonthWidget extends StatefulWidget {
  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
        _expenses(),
        _graph(),
        Container(
          color: Colors.blueAccent.withOpacity(0.15),
        ),
        _list(),
        ],
      ),
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
      child: GraphWidget(),
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
