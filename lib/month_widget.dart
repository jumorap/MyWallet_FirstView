import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'greph_widget.dart';

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  MonthWidget({Key key, this.documents}) : 
      total = documents.map((doc) => doc['value'])
          .fold(0.0, (a, b) => a + b),
      perDay = List.generate(31, (int index){
        return documents.where((doc) => doc['day'] == (index + 1))
            .map((doc) => doc['value'])
            .fold(0.0, (a, b) => a + b);
      }),
  categories = documents.fold({}, (Map<String, double> map, document) {
    if (!map.containsKey(document['category'])) {
      map[document['category']] = 0.0;
    }
    map[document['category']] += document['value'];
    return map;
  }),

        super(key: key);
  
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
          height: 10.0,
        ),
        _list(),
        ],
      ),
    );
  }
  Widget _expenses() {
    return Column(
        children: <Widget>[
          Text("\$${widget.total.toStringAsFixed(0)} COP", //Next lines give style to Text
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
              )
          ),
          Text("Gastos totales", //Next lines give style to Text
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blueGrey
            ),
          ),
        ],
    );
  }

  Widget _graph() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 180.5,
        child: GraphWidget(
            data: widget.perDay,
        ),
      ),
    ); // Container
  }

  Widget _item(IconData icon, String name, int percent, int value){
    return ListTile(
      leading: Icon(icon, size: 26.0),
      title: Text(name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      subtitle: Text("$percent% de gastos",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.blueGrey,
        ),
      ),
      trailing: Container(
        //Realice a container-decoration to write the value
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(//This is a PADDING, is so util to give a nice appearance
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
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return _item(FontAwesomeIcons.shoppingCart, key, 100 * data ~/ widget.total , data ~/ 1);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 4.0,
          );
        },
      ),
    );
  }
}
