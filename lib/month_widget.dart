import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emulateios/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'greph_widget.dart';
import 'package:intl/intl.dart';

enum GraphType {
  LINES,
  PIE,
}

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final GraphType graphType;
  final int month;

  MonthWidget({Key key, @required this.graphType, this.documents, this.month}) :
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
    // Imported 'package:intl/intl.dart', we can give format to [widget.total], doing friendly how this look to our users
    // is used wrote the next line, and after taking the variable [widget.total] so: f.format([variable])
    NumberFormat f = new NumberFormat("#,###", "es_COP");
    return Column(
        children: <Widget>[
          Text("\$${f.format(widget.total)} COP", //Next lines give style to Text
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
    if (widget.graphType == GraphType.LINES) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 180.5,
          child: LinesGraphWidget(
            data: widget.perDay,
          ),
        ),
      ); // Container
    } else {
      var perCategory = widget.categories.keys.map((name) => widget.categories[name] / widget.total).toList();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 180.5,
          child: PieGraphWidget(
            data: perCategory,
          ),
        ),
      ); // Container
    }
  }

  Widget _item(IconData icon, String name, double percent, int value){
    NumberFormat f = new NumberFormat("#,###", "es_COP");
    return ListTile(
      // We gonna do selectable the list of items where appear the expenses.
      // In this case, we know that ListTile is prepared to use onTap directly,
      // them, we don't use GestureListener to do selectable an item
      onTap: () {
        Navigator.of(context).pushNamed('/details', arguments: DetailsParams(name, widget.month));
      },
      leading: Icon(icon, size: 26.0),
      title: Text(name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      subtitle: Text("${percent.toStringAsFixed(2)}% de gastos",
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
          child: Text("\$${f.format(value)}",
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
          String keyStr = key.toString();
          IconData iconSend;
          if (keyStr == "Compras") iconSend = FontAwesomeIcons.shoppingCart;
          else if (keyStr == "Diversión") iconSend = FontAwesomeIcons.beer;
          else if (keyStr == "Alimentos") iconSend = FontAwesomeIcons.hamburger;
          else if (keyStr == "Servicios") iconSend = FontAwesomeIcons.wallet;
          else if (keyStr == "Tarjetas") iconSend = FontAwesomeIcons.creditCard;
          else if (keyStr == "Salud") iconSend = FontAwesomeIcons.heartbeat;
          else if (keyStr == "Transporte") iconSend = FontAwesomeIcons.busAlt;
          else if (keyStr == "Educación") iconSend = FontAwesomeIcons.university;
          else if (keyStr == "Impuestos") iconSend = FontAwesomeIcons.listAlt;
          else if (keyStr == "Imprevisto") iconSend = FontAwesomeIcons.frown;

          return _item(iconSend, key, 100 * data / widget.total , data ~/ 1);
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
